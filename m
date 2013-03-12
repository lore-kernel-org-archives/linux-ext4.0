From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [REGRESSION] allocated N with only M reserved metadata blocks
Date: Tue, 12 Mar 2013 15:11:23 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1303121502240.7128@dhcp-1-104.brq.redhat.com>
References: <20130311185423.GA15478@thunk.org> <20130311210201.GA940@wallace> <20130311212239.GD15478@thunk.org> <alpine.LFD.2.00.1303120838170.7128@dhcp-1-104.brq.redhat.com> <alpine.LFD.2.00.1303121020590.7128@dhcp-1-104.brq.redhat.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="571107329-715946414-1363097487=:7128"
Cc: "Theodore Ts'o" <tytso@mit.edu>, Eric Whitney <enwlinux@gmail.com>,
	linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14974 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754180Ab3CLOLd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Mar 2013 10:11:33 -0400
In-Reply-To: <alpine.LFD.2.00.1303121020590.7128@dhcp-1-104.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--571107329-715946414-1363097487=:7128
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Tue, 12 Mar 2013, Luká¨ Czerner wrote:

> Date: Tue, 12 Mar 2013 10:48:27 +0100 (CET)
> From: Luká¨ Czerner <lczerner@redhat.com>
> To: Luká¨ Czerner <lczerner@redhat.com>
> Cc: Theodore Ts'o <tytso@mit.edu>, Eric Whitney <enwlinux@gmail.com>,
>     linux-ext4@vger.kernel.org
> Subject: Re: [REGRESSION] allocated N with only M reserved metadata blocks
> 
> On Tue, 12 Mar 2013, Luká¨ Czerner wrote:
> 
> > Date: Tue, 12 Mar 2013 08:58:53 +0100 (CET)
> > From: Luká¨ Czerner <lczerner@redhat.com>
> > To: Theodore Ts'o <tytso@mit.edu>
> > Cc: Eric Whitney <enwlinux@gmail.com>, linux-ext4@vger.kernel.org
> > Subject: Re: [REGRESSION] allocated N with only M reserved metadata blocks
> > 
> > On Mon, 11 Mar 2013, Theodore Ts'o wrote:
> > 
> > > Date: Mon, 11 Mar 2013 17:22:39 -0400
> > > From: Theodore Ts'o <tytso@mit.edu>
> > > To: Eric Whitney <enwlinux@gmail.com>
> > > Cc: linux-ext4@vger.kernel.org
> > > Subject: Re: [REGRESSION] allocated N with only M reserved metadata blocks
> > > 
> > > On Mon, Mar 11, 2013 at 05:02:01PM -0400, Eric Whitney wrote:
> > > > 
> > > > FWIW, this might not be a regression.  I believe I've got this warning in my
> > > > testing logs from both 3.8 and 3.8-rc7 (commit 01a523eb51 in 3.9-rc1 affects
> > > > message format and line numbering) on both x86 and ARM.  I didn't run xfstest
> > > > 127 prior to 3.8-rc7, so I don't know how far back the warning may have
> > > > occurred for that particular test.
> > > > 
> > > > The 3.8-rc7 results are a little different with respect to number of warnings
> > > > and test cases, so I'm thinking this one isn't completely deterministic,
> > > > testing-wise.  Multiple test runs may be required to see it.
> > > 
> > > Thanks for the extra data; this saved be a whole bunch of time, since
> > > I probably would have started doing a series git bisects tonight.   :-)
> > > 
> > >   	   	      	      	      - Ted
> > 
> > I found that the problem is present even in 3.7.0, however it is not
> > present in 3.6.0. I guess we need to bisect now :)
> > 
> > -Lukas
> 
> Apparently the problem is caused by the commit:
> 
> 67a5da564f97f31c4054d358e00b34d7ee570da5 ext4: make the zero-out
> chunk size tunable
> 
> Reverting that commit on 3.7 makes the warning disappear. I'll try
> to see what's going on there, however from the nature of the change
> it seems to me that the problem might have always been there but the
> change just makes it easier/possible to hit. We'll see...
> 
> -Lukas

So there is indeed a problem with the mentioned commit

67a5da564f97f31c4054d358e00b34d7ee570da5

Due to the bug in that code is has exactly the opposite result -
with this commit we will _never_ zero out blocks instead of creating
uninitialized extents. In other words, we will always create
uninitialized extent.

This can be easily fixed by the following patch (which makes the
warning go away), but it brings up a question whether this "optimization"
was worth it in the first place since noone noticed that it had exactly
the opposite effect than it should have had :)

However it still does not resolve the issue completely, because even
without the zeroout we should have had reserved enough metadata
blocks to cover the extent split. I still need to investigate
a little bit further.

-Lukas

---

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index cac80120..aeb80bc 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3227,7 +3227,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 
 	if (EXT4_EXT_MAY_ZEROOUT & split_flag)
 		max_zeroout = sbi->s_extent_max_zeroout_kb >>
-			inode->i_sb->s_blocksize_bits;
+			(inode->i_sb->s_blocksize_bits - 10);
 
 	/* If extent is less than s_max_zeroout_kb, zeroout directly */
 	if (max_zeroout && (ee_len <= max_zeroout)) {
--571107329-715946414-1363097487=:7128--
