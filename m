From: Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
Subject: Re: [PATCH 5 2/4] Return 32/64-bit dir name hash according to usage
 type
Date: Tue, 24 Apr 2012 18:10:51 +0200
Message-ID: <4F96D08B.2020606@itwm.fraunhofer.de>
References: <20120109132137.2616029.76288.stgit@localhost.localdomain> <20120109132148.2616029.68798.stgit@localhost.localdomain> <4F91C15B.6070200@redhat.com> <4F93FED6.6090505@itwm.fraunhofer.de> <4F95BD72.6090200@redhat.com> <4F95C109.1030401@itwm.fraunhofer.de> <4F95D65A.8070608@redhat.com> <A754D23B-B946-4E80-ACEA-0E2C2E6FAA2E@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Fan Yong <yong.fan-KloliPT79xf2eFz/2MeuCQ@public.gmane.org>, bfields-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: Andreas Dilger <adilger-KloliPT79xf2eFz/2MeuCQ@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <A754D23B-B946-4E80-ACEA-0E2C2E6FAA2E-KloliPT79xf2eFz/2MeuCQ@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On 04/24/2012 12:42 AM, Andreas Dilger wrote:
> On 2012-04-23, at 5:23 PM, Eric Sandeen wrote:
>> I'm curious about the above as well as:
>>
>>         case SEEK_END:
>>                 if (unlikely(offset>  0))
>>                         goto out_err; /* not supported for directories */
>>
>> The previous .llseek handler, and the generic handler for other filesystems, allow seeking past the end of the dir AFAICT.  (not sure why you'd want to, but I don't see that you'd get an error back).
>>
>> Is there a reason to uniquely exclude it in ext4?  Does that line up with POSIX?
>
> I don't know what the origin of this was...  I don't think there is a real reason for it except that it doesn't make any sense to do so.
>

I think I added that. According to pubs.opengroup.org:
(http://pubs.opengroup.org/onlinepubs/009695399/functions/seekdir.html)

void seekdir(DIR *dirp, long loc);

<quote>

If the value of loc was not obtained from an earlier call to telldir(), 
or if a call to rewinddir() occurred between the call to telldir() and 
the call to seekdir(), the results of subsequent calls to readdir() are 
unspecified.

</quote>


As telldir(), which should correlate to 'case SEEK_CUR' will not provide 
invalid values, the behaviour is undefined.


Also,


case SEEK_END:
[...]
                 if (dx_dir)
                         offset += ext4_get_htree_eof(file);
                 else
                         offset += inode->i_size;
[...]


         if (!dx_dir) {
                 if (offset > inode->i_sb->s_maxbytes)
                         goto out_err;
         } else if (offset > ext4_get_htree_eof(file))
                 goto out_err;




Hence, the additional:

          case SEEK_END:
                  if (unlikely(offset>  0))
                       goto out_err; /* not supported for directories */

	
is just a shortcut to avoid useless calculations.

Unless I missed something, it only remains the question if could break 
existing applications relying on undefined behaviour. However, I have no 
idea how an application might trigger that?


Thanks,
Bernd

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
