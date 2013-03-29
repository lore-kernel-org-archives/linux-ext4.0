From: Tao Ma <tm@tao.ma>
Subject: Re: [PATCH 2/2] ext4: Handle readdir when a file is converted from
 inline to block based.
Date: Fri, 29 Mar 2013 10:03:38 +0800
Message-ID: <5154F67A.8020401@tao.ma>
References: <1364466899-5599-1-git-send-email-tm@tao.ma> <1364466899-5599-2-git-send-email-tm@tao.ma> <20130328184412.GF16651@lenny.home.zabbo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Zach Brown <zab@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:56506 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754546Ab3C2CDp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Mar 2013 22:03:45 -0400
In-Reply-To: <20130328184412.GF16651@lenny.home.zabbo.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 03/29/2013 02:44 AM, Zach Brown wrote:
>> Zach reported that if a dir is inlined, the offset is within the inode, while
>> if we have done the conversion, the dir now will have a block offset or even
>> a hashed pos. The good thing is that ext4 is also prepared to handle some
>> situation that the dir is changed during many calls of getdents.
> 
> This doesn't fix the problem.  The problem isn't using the right code
> path within ext4 for either inline or normal block directories.
> 
> The problem is that offsets for existing files change.  Yeah, ext4 also
> has this problem when it converts from classic linear dirents to hashed
> dirents, but I bet that basically doesn't happen any more.  Inline dirs
> are making the problem happen for every single directory as it grows.
Thanks for the explanation. I just looked deep into the problem and yes,
the code is really tricky for an old linear dir. Now it also uses the
ext4_dx_readdir, so the situation you described doesn't happen...

Maybe I will also need to pretend as if inline dir is hashed like the
normal linear dir and return the hash value as the pos.

Thanks,
Tao
> 
> There's two ways to experience the bug:
> 
> 1) nfs clients getting the wrong entry because the offset has changed
> from the time that they got it from the server
> 
> 2) more worryingly: a concurrent readdir() can see duplicate entries
> from simply advancing f_pos as it does normally
> 
> Here's a quick little demonstration of the second case:
> 
> d_off: 2 d_name: ., f_pos 2
> d_off: 4 d_name: .., f_pos 4
> d_off: 16 d_name: a, f_pos 16
> d_off: 28 d_name: b, f_pos 28
> d_off: 40 d_name: c, f_pos 40
> d_off: 371778706554281332 d_name: .., f_pos 18446744071750344052
> d_off: 1068979911240654558 d_name: b, f_pos 18446744072795659998
> d_off: 6187216788877381273 d_name: c, f_pos 1633586841
> d_off: 6280769109141524706 d_name: e, f_pos 1386254562
> 
> Run the following in a newly created empty dir with inline_data:
> 
> #include <stdlib.h>
> #include <dirent.h>
> #include <stdio.h>
> #include <sys/types.h>
> #include <sys/stat.h>
> #include <fcntl.h>
> #include <errno.h>
> #include <string.h>
> #include <sys/syscall.h>
> 
> struct linux_dirent {
> 	long           d_ino;
> 	off_t          d_off;
> 	unsigned short d_reclen;
> 	char           d_name[];
> };
> 
> int main(int argc, char **argv)
> {
> 	struct linux_dirent dent;
> 	char name[2] = {0,};
> 	int i;
> 	int ret;
> 	int fd;
> 
> 	fd = open(".", O_RDONLY | O_DIRECTORY);
> 	if (fd < 0) {
> 		printf("open(\".\", O_RDONLY|O_DIRECTORY) failed: %u (%s)\n",
> 		       errno, strerror(errno));
> 		exit(1);
> 	}
> 	
> 	for (i = 0; i < 26; i++) {
> 		name[0] = 'a' + i;
> 		mknod(name, S_IFREG|0755, 0);
> 		ret = syscall(SYS_getdents, fd, &dent, sizeof(dent));
> 		if (ret < 1)
> 			break;
> 		printf("d_off: %llu d_name: %s, f_pos %llu\n",
> 		       (unsigned long long)dent.d_off,
> 		       dent.d_name,
> 		       (unsigned long long)lseek(fd, 0, SEEK_CUR));
> 	}
> 
> 	return 0;
> }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

