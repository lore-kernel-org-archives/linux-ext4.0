From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 0/4] ext4: DAX fixes
Date: Mon, 16 May 2016 11:29:38 -0700
Message-ID: <CAPcyv4jZGOR33ddxQT4FGFVSK2FMt9+ds_Unf8wmPf4zpJGi7w@mail.gmail.com>
References: <1462959551-28622-1-git-send-email-jack@suse.cz>
	<20160513052419.GD5862@thunk.org>
	<20160513135600.GA2996@thunk.org>
	<20160516093525.GD12026@quack2.suse.cz>
	<20160516142616.GB21714@quack2.suse.cz>
	<20160516150820.GJ7799@thunk.org>
	<CAPcyv4iVQadEC-23B36QX-2=vioVniRB+_tSh6ro+dCHKkQzuA@mail.gmail.com>
	<20160516155950.GF21714@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-nvdimm <linux-nvdimm@ml01.01.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:35434 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874AbcEPS3j (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 May 2016 14:29:39 -0400
Received: by mail-oi0-f45.google.com with SMTP id x19so281276273oix.2
        for <linux-ext4@vger.kernel.org>; Mon, 16 May 2016 11:29:39 -0700 (PDT)
In-Reply-To: <20160516155950.GF21714@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 16, 2016 at 8:59 AM, Jan Kara <jack@suse.cz> wrote:
> On Mon 16-05-16 08:13:50, Dan Williams wrote:
>> On Mon, May 16, 2016 at 8:08 AM, Theodore Ts'o <tytso@mit.edu> wrote:
>> > On Mon, May 16, 2016 at 04:26:16PM +0200, Jan Kara wrote:
>> >> 1) Just push patches as is and have ext4 dax broken between ext4 merge and
>> >> nvdimm merge.
>> >>
>> >> 2) Split out the one-line change from "dax: Remove dead zeroing code from
>> >> fault handlers" in __dax_fault() which fixes the behavior for ext4 and
>> >> merge it through ext4 tree. Merge the rest through nvdimm tree.
>> >
>> > I'm good either way, although I have a slight preference for (2).
>> > It's really tiny preference, though, so if you or Dan want to run the
>> > fix through the dax branch, that's fine too.
>>
>> Would you fold the change and trigger a rebase or just apply it on
>> top?  If just applying on top then it seems the same exposure as
>> merging it intact through nvdimm.git.
>
> The patch which fixes ext4 behavior is attached. Just that we know what we
> are speaking about... Rebasing all the patches on top of this is trivial
> (git rebase just handles the conflict automatically).
>
> I've scheduled full ext4 & XFS xfstest run with just this patch and ext4
> fixes to make sure it doesn't introduce some intermediate regresion
> somewhere.
>

Ok, sounds good.  It makes the most sense to base the nvdimm.git
branch on top of this fix.
