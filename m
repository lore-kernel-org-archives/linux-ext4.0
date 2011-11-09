From: Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/4] 32/64 bit llseek hashes (v4)
Date: Wed, 09 Nov 2011 08:59:29 -0600
Message-ID: <4EBA9551.4000404@redhat.com>
References: <20110817095717.1879649.41075.stgit@fsdevel3> <4E5D6058.8040805@fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yong.fan-KloliPT79xf2eFz/2MeuCQ@public.gmane.org,
	adilger-KloliPT79xf2eFz/2MeuCQ@public.gmane.org, "J. Bruce Fields" <bfields-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	"Ted Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>
To: Bernd Schubert <bernd.schubert-97jfqw80gc6171pxa8y+qA@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E5D6058.8040805-97jfqw80gc6171pxa8y+qA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On 8/30/11 5:12 PM, Bernd Schubert wrote:
> On 08/17/2011 11:57 AM, Bernd Schubert wrote:
>> With the ext3/ext4 directory index implementation hashes are used to specify
>> offsets for llseek(). For compatibility with NFSv2 and 32-bit user space
>> on 64-bit systems (kernel space) ext3/ext4 currently only return 32-bit
>> hashes and therefore the probability of hash collisions for larger directories
>> is rather high. As recently reported on the NFS mailing list that theoretical
>> problem also happens on real systems:
>> http://comments.gmane.org/gmane.linux.nfs/40863
>>
>> The following series adds two new f_mode flags to tell ext4
>> to use 32-bit or 64-bit hash values for llseek() calls.
>> These flags can then used by network file systems, such as NFS, to
>> request 32-bit or 64-bit offsets (hashes).
>>
>> Version 4
>> - Andreas noticed there was HAVE_IS_COMPAT_TASK instead of
>>    CONFIG_COMPAT in the
>>    "Return 32/64-bit dir name hash according to usage type"
>>    patch
>>
>> Version 3:
>> - remove patch "RFC: Remove check for a 32-bit cookie in nfsd4_readdir()",
>>    I think Bruce wanted to take it seperately as bug fix. It should be applied
>>    before applying the remaining NFS patches, as without it NFSv4 will always
>>    fail with the new 64-bit ext4 seek hashes.
>> - split "nfsd: vfs_llseek() with 32 or 64 bit offsets (hashes)" into two
>>    two separate patches as suggested by Bruce, one patch to rename
>>    'access' to 'may_flags'. And the remainder of the original patch to set
>>    FMODE_32BITHASH/FMODE_64BITHASH flags and to introduce the new
>>    NFSD_MAY_64BIT_COOKIE flag
>>
>> Version 2:
>> - use f_mode instead of O_* flags and also in a separate patch
>> - introduce EXT4_HTREE_EOF_32BIT and EXT4_HTREE_EOF_64BIT
>> - fix SEEK_END in ext4_dir_llseek()
>> - set f_mode flags in NFS code as early as possible and introduce a new
>>    NFSD_MAY_64BIT_COOKIE flag for that
>>
> 
> Ted,
> 
> any chance you could take this series or at least ack the ext4 part? Bruce already acked the NFS patches.
> 
> 
>     Acked-by: J. Bruce Fields <bfields-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 

Ted, what is the status of these patches for ext4 at this point?

-eric

> 
> Thanks,
> Bernd
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
