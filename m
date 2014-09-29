From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: resize2fs problem with stride calc
Date: Mon, 29 Sep 2014 16:46:25 -0600
Message-ID: <51356613-F400-4DF9-804A-D0220EBDA467@dilger.ca>
References: <BAY179-W85AF983234DB78F07A12EFDB50@phx.gbl> <541EF912.7000801@redhat.com> <BAY179-W21A504DA0A8A8D30C139F3FDB20@phx.gbl> <20140929205929.GA27728@birch.djwong.org>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: multipart/signed; boundary="Apple-Mail=_CB980E9D-D21B-43CD-BF73-0C4ED75F1125"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: TR Reardon <thomas_reardon@hotmail.com>,
	Eric Sandeen <sandeen@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:38990 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbaI2Wqa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Sep 2014 18:46:30 -0400
Received: by mail-pa0-f51.google.com with SMTP id lj1so3562742pab.38
        for <linux-ext4@vger.kernel.org>; Mon, 29 Sep 2014 15:46:29 -0700 (PDT)
In-Reply-To: <20140929205929.GA27728@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_CB980E9D-D21B-43CD-BF73-0C4ED75F1125
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=iso-8859-1


On Sep 29, 2014, at 2:59 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> 
> It'll end up recalculating stride for any flexbg FS with more than
> 12 BGs and more than 3 flexbgs.  This piece is neither a part of nor
> is used for 32>64bit conversion.
> 
> AFAICT, the point of determine_fs_stride() is to try to recover the
> RAID stride by inferring it from minor variations in the block/inode
> bitmap locations between successive block groups.  This explodes when
> flexbg is turned on because bitmap blocks are stored in "other" bgs
> and there's a "big jump" between the bitmaps in the last bg of one
> flexbg and the bitmaps of the first bg of the next flexbg.  Between
> bgs in a single flexbg the *_stride values are "negative" and don't
> contribute to the stride calculation.
> 
> I /think/ the solution is to ignore first blockgroup when crossing a
> flexbg boundary when there are flexbgs.  Can you give the following
> patch a spin?  It shouldn't spit out "group XXX has stride..." messages
> after that.  I'm not sure that "negative" stride ought to be ignored
> either, but....
> 
> Honestly I'd rather just kill the whole thing, but someone must've had
> a reason to put it there?  Ted?

I added this to try and preserve the RAID stride while doing the resize,
to avoid making one disk in a RAID be a hot-spot for bitmap updates.
With flex_bg the RAID stride becomes less critical, because the bitmaps
are contiguous and will naturally span the RAID stripes if the flex_bg
factor is large enough to have blocks on every stripe.

We normally specify the flex_bg factor to be 256 (== 1MB of contiguous
bitmaps) to exactly match the RAID stripe width when formatting Lustre,
so we don't need the stride for this, but still specify it to help the
mballoc align the IO blocks properly.

I haven't given much though about what happens if these two do not line
up evenly.

Cheers, Andreas

> --D
> 
> diff --git a/resize/main.c b/resize/main.c
> index 060e67d..b993dfb 100644
> --- a/resize/main.c
> +++ b/resize/main.c
> @@ -105,6 +105,7 @@ static void determine_fs_stride(ext2_filsys fs)
> 	unsigned long long sum;
> 	unsigned int	has_sb, prev_has_sb = 0, num;
> 	int		i_stride, b_stride;
> +	int		flexbg_size = 1 << fs->super->s_log_groups_per_flex;
> 
> 	if (fs->stride)
> 		return;
> @@ -120,10 +121,11 @@ static void determine_fs_stride(ext2_filsys fs)
> 			ext2fs_inode_bitmap_loc(fs, group - 1) -
> 			fs->super->s_blocks_per_group;
> 		if (b_stride != i_stride ||
> -		    b_stride < 0)
> +		    b_stride < 0 ||
> +		    (flexbg_size > 1 && (group % flexbg_size == 0)))
> 			goto next;
> 
> -		/* printf("group %d has stride %d\n", group, b_stride); */
> +		printf("group %d has stride %d %d\n", group, b_stride, i_stride);
> 		sum += b_stride;
> 		num++;
> 
> @@ -133,7 +135,7 @@ static void determine_fs_stride(ext2_filsys fs)
> 
> 	if (fs->group_desc_count > 12 && num < 3)
> 		sum = 0;
> -
> +printf("sum is %llu %u\n", sum, num);
> 	if (num)
> 		fs->stride = sum / num;
> 	else
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_CB980E9D-D21B-43CD-BF73-0C4ED75F1125
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVCnhQXKl2rkXzB/gAQIWhA//diYneOnBEh6qfvOPdeWjEwrcssmvnpDB
uygFsff+4U1W94jO2AQkTVqOiB6u5qqFItaUk5Kbdqw/GR3t6QiKeUsHNs87yGEH
1F1n35s7lYJUX9hfem4+64MFSLWBSjyG9v4m5rn8uZZTH8GjMPZLCJtIHZ09DnLU
surrf92RCqg9n70azOgAuFls3bGjuOPZC93UFpBIiRHk9YC54UoAI6u8ZfrtyDUV
CyxI3uvxZehurGsdyfWYpEk+wqhBVUztt+mfI+4yDOqnWSnvYmmUwob21q++zFzX
Mr+EJjrYuUWNTA8CY9ELSY/oJ/9f9bF3SHZhicth8PA9a4uVtYjAjA9Grq8yONQJ
W1dJzxrdbBO+GxSi5Ua36EtpNfDonOsXVic8vl6y1VfmRVubeuQK5VerwwtnWD5n
sZahaPKLBL6/GuvubCCcB2U7EFQ/7CgHiOSAWeekE8qYHG6mu0krj7kCNThnmDYC
3e4AK65VfDSRBA95e7XaD2hoiBqqziMCpNTIil1s+s+TfUf9pAFPdhNB0Jrknh73
jBVqcLWH+46ofdLPPk7GeOc+GqRudaXYMPpg24c/o9et1CRnSXVhNazac0GqhVgt
XYjWtOKHJ0upJ2XaStDaieYNGc8xHvlbidKRphmq6P5jmPE4kxVSIQIOKR5+3234
t15UKK1NOoQ=
=kbMB
-----END PGP SIGNATURE-----

--Apple-Mail=_CB980E9D-D21B-43CD-BF73-0C4ED75F1125--
