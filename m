From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/2] jbd2: fix descriptor block size handling errors with
 journal_csum
Date: Mon, 8 Sep 2014 16:18:42 -0700
Message-ID: <20140908231842.GA12894@birch.djwong.org>
References: <BAY406-EAS2912CB28A4B081AF994BDA2FDC70@phx.gbl>
 <20140906040154.GA27293@birch.djwong.org>
 <20140906042734.GA10351@birch.djwong.org>
 <BAY179-W502087BB782D5AD3D06197FDC10@phx.gbl>
 <BAY179-W21189CCAAFFB4BA9D7CF1BFDC10@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: TR Reardon <thomas_reardon@hotmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40989 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755009AbaIHXSs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Sep 2014 19:18:48 -0400
Content-Disposition: inline
In-Reply-To: <BAY179-W21189CCAAFFB4BA9D7CF1BFDC10@phx.gbl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 08, 2014 at 11:10:41AM -0400, TR Reardon wrote:
> This updated patch was tested and works. Created fs with journal_checksum_v2
> on Debian kernel 3.14 (which remains unaware of journal_checksum_v3), touched
> files, clean dismount, then mounted under 3.16.2 with this updated patch
> which cleanly upgrades to journal_checksum_v3

Ok good, I officially sent the patch to the list a little while ago.

>  One aside, I noticed that the original patch was picked up for 3.14 and 3.16
>  stable, but not for 3.10-stable or 3.12-stable; seems like it should have
>  been?

Probably all three of the jbd2 patches ought to be sent to 3.{10,12,14,16}
stable.

--D

> 
>  +Reardon
> 
> > Date: Fri, 5 Sep 2014 21:27:34 -0700
> > From: darrick.wong@oracle.com
> > To: thomas_reardon@hotmail.com
> > CC: tytso@mit.edu; linux-ext4@vger.kernel.org
> > Subject: Re: [PATCH 2/2] jbd2: fix descriptor block size handling errors with journal_csum
> > 
> > On Fri, Sep 05, 2014 at 09:01:54PM -0700, Darrick J. Wong wrote:
> >> On Tue, Sep 02, 2014 at 03:28:33PM -0400, TR Reardon wrote:
> >>> There may still be problems with this patch. After applying to 3.16.1, I am now getting "can't enable checksumming v2 and v3 at the same time" errors on mount. Initial mount/dismount work fine, but once fs is touched--forcing superblock update--it cannot be mounted anew.
> >>> 
> >>> Note results from dumpe2fs (without recent patches)
> >>> 
> >>> Journal backup: inode blocks
> >>> Checksum type: crc32c
> >>> Checksum: 0x39141b69
> >>> Journal features: journal_incompat_revoke journal_64bit journal_async_commit journal_checksum_v2 FEATURE_I4
> >>> Journal size: 128M
> >>> Journal length: 32768
> >>> Journal sequence: 0x00012aa4
> >>> Journal start: 0
> >>> Journal checksum type: crc32c
> >>> Journal checksum: 0x3952b695
> >>> 
> >>> Seems that the old v2 flag is not cleared on dismount?
> >> 
> >> Yep. Thanks for catching this.
> > 
> > Also, would you mind testing this patch? I think it'll suffice to clear all
> > the journal flags before enabling whichever one we want.
> > 
> > --D
> > 
> > diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> > index 0b28b36..aff945d 100644
> > --- a/fs/ext4/super.c
> > +++ b/fs/ext4/super.c
> > @@ -3190,6 +3190,10 @@ static int set_journal_csum_feature_set(struct super_block *sb)
> > incompat = 0;
> > }
> > 
> > + jbd2_journal_clear_features(sbi->s_journal,
> > + JBD2_FEATURE_COMPAT_CHECKSUM, 0,
> > + JBD2_FEATURE_INCOMPAT_CSUM_V3 |
> > + JBD2_FEATURE_INCOMPAT_CSUM_V2);
> > if (test_opt(sb, JOURNAL_ASYNC_COMMIT)) {
> > ret = jbd2_journal_set_features(sbi->s_journal,
> > compat, 0,
> > @@ -3202,11 +3206,8 @@ static int set_journal_csum_feature_set(struct super_block *sb)
> > jbd2_journal_clear_features(sbi->s_journal, 0, 0,
> > JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT);
> > } else {
> > - jbd2_journal_clear_features(sbi->s_journal,
> > - JBD2_FEATURE_COMPAT_CHECKSUM, 0,
> > - JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT |
> > - JBD2_FEATURE_INCOMPAT_CSUM_V3 |
> > - JBD2_FEATURE_INCOMPAT_CSUM_V2);
> > + jbd2_journal_clear_features(sbi->s_journal, 0, 0,
> > + JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT);
> > }
> > 
> > return ret;
> > -- 		 	   		  
