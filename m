From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 0/4] ext4: DAX fixes
Date: Mon, 16 May 2016 08:13:50 -0700
Message-ID: <CAPcyv4iVQadEC-23B36QX-2=vioVniRB+_tSh6ro+dCHKkQzuA@mail.gmail.com>
References: <1462959551-28622-1-git-send-email-jack@suse.cz>
	<20160513052419.GD5862@thunk.org>
	<20160513135600.GA2996@thunk.org>
	<20160516093525.GD12026@quack2.suse.cz>
	<20160516142616.GB21714@quack2.suse.cz>
	<20160516150820.GJ7799@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Jan Kara <jack@suse.cz>, linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-nvdimm <linux-nvdimm@ml01.01.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20160516150820.GJ7799@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, May 16, 2016 at 8:08 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Mon, May 16, 2016 at 04:26:16PM +0200, Jan Kara wrote:
>> 1) Just push patches as is and have ext4 dax broken between ext4 merge and
>> nvdimm merge.
>>
>> 2) Split out the one-line change from "dax: Remove dead zeroing code from
>> fault handlers" in __dax_fault() which fixes the behavior for ext4 and
>> merge it through ext4 tree. Merge the rest through nvdimm tree.
>
> I'm good either way, although I have a slight preference for (2).
> It's really tiny preference, though, so if you or Dan want to run the
> fix through the dax branch, that's fine too.

Would you fold the change and trigger a rebase or just apply it on
top?  If just applying on top then it seems the same exposure as
merging it intact through nvdimm.git.
