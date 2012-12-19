From: Eric Sandeen <esandeen@redhat.com>
Subject: Re: [PATCH RFC] jbd: don't wake kjournald unnecessarily
Date: Wed, 19 Dec 2012 16:19:25 -0500 (EST)
Message-ID: <83739F77-AB54-449D-B063-C6DCD3534D2B@redhat.com>
References: <50D0A1FD.7040203@redhat.com> <20121219012710.GF5987@quack.suse.cz> <20121219020526.GG5987@quack.suse.cz> <50D12FC3.6090209@redhat.com> <20121219081334.GB20163@quack.suse.cz> <20121219153725.GD7795@thunk.org> <20121219171401.GB28042@quack.suse.cz> <20121219202734.GA18804@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx3-phx2.redhat.com ([209.132.183.24]:45559 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907Ab2LSVUK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Dec 2012 16:20:10 -0500
In-Reply-To: <20121219202734.GA18804@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Dec 19, 2012, at 2:27 PM, "Theodore Ts'o" <tytso@mit.edu> wrote:

> On Wed, Dec 19, 2012 at 06:14:01PM +0100, Jan Kara wrote:
>>  I agree. Just I'm still somewhat puzzled by those two reports pointed to
>> by Eric. In both cases stored tids were 0 and I cannot see how that happens
>> (well how it could happen in a reasonably likely way).
> 
> I'm also really puzzled about how Eric's patch makes a 10% different
> on the AIM7 benchmark; as you've pointed out, that will just cause an
> extra wakeup of the jbd/jbd2 thread, which should then quickly check
> and decide to go back to sleep.

TBH I'm puzzled too, but that's what the perf guys tell me...

Eric

>                    - Ted
