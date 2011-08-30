From: Bernd Schubert <bernd.schubert-97jfqw80gc6171pxa8y+qA@public.gmane.org>
Subject: Re: [PATCH 0/2] 32/64 bit llseek hashes (v3)
Date: Tue, 30 Aug 2011 23:59:23 +0200
Message-ID: <4E5D5D3B.7010402@fastmail.fm>
References: <20110816115404.1810393.47239.stgit@localhost.localdomain> <20110823215608.GH25350@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	tytso-3s7WtUTddSA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, adilger-KloliPT79xf2eFz/2MeuCQ@public.gmane.org,
	yong.fan-KloliPT79xf2eFz/2MeuCQ@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110823215608.GH25350-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On 08/23/2011 11:56 PM, J. Bruce Fields wrote:
> On Tue, Aug 16, 2011 at 01:54:04PM +0200, Bernd Schubert wrote:
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
>> Version 3:
>> - remove patch "RFC: Remove check for a 32-bit cookie in nfsd4_readdir()",
>>    I think Bruce wanted to take it seperately as bug fix. It should be applied
>>    before applying the remaining NFS patches, as without it NFSv4 will always
>>    fail with the new 64-bit ext4 seek hashes.
>
> Yes, applied to my for-3.2 branch at
> git://linux-nfs.org/~bfields/linux.git.
>
> For the NFS patches:
>
> 	Acked-by: J. Bruce Fields<bfields-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
> OK by me if they go in through ext4 tree, or however's most convenient.

Great, thanks!


Cheers,
Bernd
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
