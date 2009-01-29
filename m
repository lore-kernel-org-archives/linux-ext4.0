From: Mike Snitzer <snitzer@gmail.com>
Subject: Re: [PATCH] ext3: wait on all pending commits in ext3_sync_fs
Date: Thu, 29 Jan 2009 13:27:37 -0500
Message-ID: <170fa0d20901291027g601c8674o9ec5daf67d4ad0de@mail.gmail.com>
References: <4908C951.2000309@redhat.com>
	 <20081103184426.GA31894@ajones-laptop.nbttech.com>
	 <20081103113318.35b0c266.akpm@linux-foundation.org>
	 <20081103201428.GB30565@ajones-laptop.nbttech.com>
	 <20081218231707.GB20092@atrey.karlin.mff.cuni.cz>
	 <496D1233.2060905@redhat.com> <20090114042402.GH14730@mit.edu>
	 <20090114172750.GJ19950@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Arthur Jones <ajones@riverbed.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"sct@redhat.com" <sct@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.229]:28007 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171AbZA2S1i (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 29 Jan 2009 13:27:38 -0500
In-Reply-To: <20090114172750.GJ19950@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 14, 2009 at 12:27 PM, Jan Kara <jack@suse.cz> wrote:
> On Tue 13-01-09 23:24:02, Theodore Tso wrote:
>> On Tue, Jan 13, 2009 at 04:14:11PM -0600, Eric Sandeen wrote:
>> >
>> > This looks sane to me, and it does fix the below testcase.
>> >
>> > Care to formally propose it?
>>
>> Can we confirm what is being proposed?  From following this thread, I
>> think what folks are suggesting is:
>>
>> 1)  Revert the current "ext3/4: wait on all pending ocmmits in ext3/4_sync_fs"
>  Yes.
>
>> 2)  Apply Jan's patch "jbd[2]: Fix return value of journal_start_commit()"
>  Yes.
>
>> 3)  Also apply Jan's patch "jbd2: Skip commit of a transaction without
>> any buffers" since it appears to be a good optimization (although it's
>> not clear it would happen once we revert (1), above.
>  Yes, it's an optimization but I'm still a bit afraid about something
> relying on jbd2_journal_force_commit() implying a barrier which would not
> always be a case after this patch... So we should probably audit all users of
> ext4_force_commit() and check that this change is fine with them.

Ted/Jan/Eric,

I just wanted to followup on this to see what the plan is.  Items 1
and 2 haven't occurred in any of the ext4.git branches that I can see.
 I could be missing something but it seems this may have slipped
through the ext[34] cracks?

Mike
