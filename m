From: Valerie Aurora <val@vaaconsulting.com>
Subject: Re: [RFC PATCH 0/3] VFS: Fix s_umount thaw/write deadlock
Date: Mon, 28 Nov 2011 13:58:42 -0700
Message-ID: <CAD-Xujmnxp+wmWc6uMBbSTZC3_60wkfUxjiHduo3ddUu8mFnwg@mail.gmail.com>
References: <CAD-Xujmjai2evYC4a4CdNPtjh_9xhbELcZePtGSS54VPRGpznA@mail.gmail.com>
	<20111027213935.GA20902@infradead.org>
	<CAD-XujmonJPfq9zUaL-ZS6zz5dfgvxtcjJwxwrxpR33LohvK9g@mail.gmail.com>
	<CAD-Xujn--+2pRMrk2OJvCbH6nbG+wiGOPp8CRAm=a8MagqV8JQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Dave Chinner <david@fromorbit.com>,
	Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Greg Freemyer <greg.freemyer@gmail.com>,
	linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
	Surbhi Palande <csurbhi@gmail.com>,
	Christopher Chaltain <christopher.chaltain@canonical.com>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAD-Xujn--+2pRMrk2OJvCbH6nbG+wiGOPp8CRAm=a8MagqV8JQ@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Oct 29, 2011 at 5:59 PM, Valerie Aurora <val@vaaconsulting.com>=
 wrote:
> On Thu, Oct 27, 2011 at 3:08 PM, Valerie Aurora <val@vaaconsulting.co=
m> wrote:
>> On Thu, Oct 27, 2011 at 2:39 PM, Christoph Hellwig <hch@infradead.or=
g> wrote:
>>> Any plans to resubmit these with the updates and in proper format?
>>
>> Yes, coming tomorrow. =A0We found more bugs during testing which
>> fortunately Surbhi Palande already fixed and submitted patches for,
>> but got lost in the shuffle.
>
> Ironically, this has been held up by a disk failure. :) A few more da=
ys.

I no longer have time to consult in addition to my full-time job, so
Canonical is taking the lead on this again.

-VAL
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
