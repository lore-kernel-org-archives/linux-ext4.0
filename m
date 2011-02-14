From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: [LSF/MM TOPIC] Drop ext2/ext3 codebase? When?
Date: Mon, 14 Feb 2011 13:59:29 -0700
Message-ID: <2D834B48-0EDF-4A39-B09E-8188C36D62A6@dilger.ca>
References: <20110203144011.GA28409@quack.suse.cz> <4D4AC4E2.701@redhat.com> <AANLkTi=YxSpgm9vYHBKdASpLOaY_U3=ggsE8yTg_G0Bc@mail.gmail.com> <20110204131739.GC4104@quack.suse.cz> <AANLkTin=6wY6y0LZCDtMGiy8vmdok=UUj-7rmsTPAVuh@mail.gmail.com> <20110214172504.GC3018@quack.suse.cz> <AANLkTimdApPPK6FkH+CPrXdNpND6_twE2voRiNhgQOOE@mail.gmail.com> <20110214195845.GD4255@thunk.org>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Amir Goldstein <amir73il@gmail.com>, Jan Kara <jack@suse.cz>,
	Michael Rubin <mrubin@google.com>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:28452 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab1BNU7a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Feb 2011 15:59:30 -0500
In-Reply-To: <20110214195845.GD4255@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-02-14, at 12:58, Ted Ts'o wrote:
> On Mon, Feb 14, 2011 at 09:00:58PM +0200, Amir Goldstein wrote:
>> Yes, of course. Upgraders won't be the ones using snapshots.
>> My intension was to state that those people installing new systems to test
>> snapshots would be functioning as testers for "ext3 mode", because:
>> 1. when no snapshots exists it boils down to testing "ext3 mode".
>> 2. it is unlikely that snapshots will mask "ext3 mode" bugs.
>> 
>> So my claim is that "ext3 mode" would benefit from a transition
>> period in which snapshots and (extens,delalloc) are mutually
>> exclusive in ext4.
> 
> Here are the requirements that I think are critical before we do this:
> 
> 1) We need to solve the testing matrix problem.  Right now "ext3 mode"
> in ext4 doesn't get enough testing as it is.  Part of the solution is
> (a) deciding on the modes that need testing, and (b) writing some
> shell scripts so that xfstests can be automatically run in all of the
> right modes.  And then it will be having some number of people
> (hopefully not just me) running said tests and reporting failures.

I think the vast majority of systems use the default ext3 features as set by "mke2fs -j": "has_journal ext_attr resize_inode dir_index filetype sparse_super large_file"

> One thing that comes to mind about your question with the
> e4b->alloc_semp causing problems.  If the only reason why we need it
> is to protect against multiple attempts to initialize different block
> groups that share the same buddy bitmap, can we solve the problem by
> ditching e4b->alloc_semp entirely, and simply using lock_page() on the
> buddy bitmap page to protect it?

With flex_bg it might make sense to just read all of the bitmaps into that page in one shot, and avoid additional seeking later.  This won't consume any additional RAM, because the page is already allocated, but can give a good performance win.

Cheers, Andreas





