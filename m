From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 5 2/4] Return 32/64-bit dir name hash according to usage
 type
Date: Tue, 24 Apr 2012 14:21:41 -0500
Message-ID: <4F96FD45.9080902@redhat.com>
References: <20120109132137.2616029.76288.stgit@localhost.localdomain> <20120109132148.2616029.68798.stgit@localhost.localdomain> <4F91C15B.6070200@redhat.com> <4F93FED6.6090505@itwm.fraunhofer.de> <4F95BD72.6090200@redhat.com> <4F95C109.1030401@itwm.fraunhofer.de> <4F95D65A.8070608@redhat.com> <A754D23B-B946-4E80-ACEA-0E2C2E6FAA2E@whamcloud.com> <4F96D08B.2020606@itwm.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@whamcloud.com>, linux-ext4@vger.kernel.org,
	Fan Yong <yong.fan@whamcloud.com>, bfields@redhat.com
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2884 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756983Ab2DXTVq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Apr 2012 15:21:46 -0400
In-Reply-To: <4F96D08B.2020606@itwm.fraunhofer.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/24/12 11:10 AM, Bernd Schubert wrote:
> On 04/24/2012 12:42 AM, Andreas Dilger wrote:
>> On 2012-04-23, at 5:23 PM, Eric Sandeen wrote:
>>> I'm curious about the above as well as:
>>>
>>>         case SEEK_END:
>>>                 if (unlikely(offset>  0))
>>>                         goto out_err; /* not supported for directories */
>>>
>>> The previous .llseek handler, and the generic handler for other
>>> filesystems, allow seeking past the end of the dir AFAICT. (not
>>> sure why you'd want to, but I don't see that you'd get an error
>>> back).
>>>
>>> Is there a reason to uniquely exclude it in ext4?  Does that line up with POSIX?
>>
>> I don't know what the origin of this was... I don't think there is
>> a real reason for it except that it doesn't make any sense to do
>> so.
>>
> 
> I think I added that. According to pubs.opengroup.org:
> (http://pubs.opengroup.org/onlinepubs/009695399/functions/seekdir.html)
> 
> void seekdir(DIR *dirp, long loc);
> 
> <quote>
> 
> If the value of loc was not obtained from an earlier call to
> telldir(), or if a call to rewinddir() occurred between the call to
> telldir() and the call to seekdir(), the results of subsequent calls
> to readdir() are unspecified.
> 
> </quote>
> 
> 
> As telldir(), which should correlate to 'case SEEK_CUR' will not
> provide invalid values, the behaviour is undefined.
> 
> 
> Also,
> 
> 
> case SEEK_END:
> [...]
>                 if (dx_dir)
>                         offset += ext4_get_htree_eof(file);
>                 else
>                         offset += inode->i_size;
> [...]
> 
> 
>         if (!dx_dir) {
>                 if (offset > inode->i_sb->s_maxbytes)
>                         goto out_err;
>         } else if (offset > ext4_get_htree_eof(file))
>                 goto out_err;
> 
> 
> 
> 
> Hence, the additional:
> 
>          case SEEK_END:
>                  if (unlikely(offset>  0))
>                       goto out_err; /* not supported for directories */
> 
>     
> is just a shortcut to avoid useless calculations.
> 
> Unless I missed something, it only remains the question if could
> break existing applications relying on undefined behaviour. However,
> I have no idea how an application might trigger that?

(other lists removed at this point, this is ext4-specific)

I know I'm being a little pedantic w/ the late review here....

It seems like the only differences between ext4_dir_llseek and the old ext4_llseek are these:

1) For SEEK_END, we now return -EINVAL for a positive offset (i.e. past EOF)
2) For SEEK_END, we seek to ext4_get_htree_eof() not to inode->i_size
3) For SEEK_SET, we impose different limits for max offset
  - s_maxbytes / ext4_get_htree_eof for !dx/dx, vs. s_bitmap_maxbytes/s_maxbytes

Do any of these changes relate to the hash collision problem?  Are any of them uniquely
required for ext4, enough to warrant cut & paste of the vfs llseek code (again?)

What I'm getting at is: what are the reasons that we cannot use generic_file_llseek_size(),
maybe with a new argument to specify a non-standard location for SEEK_END.  Such
a change would require a solid explanation, but it'd probably go in if it meant
one less seek implementation to worry about.

-Eric
