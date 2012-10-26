From: Nix <nix@esperi.org.uk>
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6.3 (and other stable branches?)
Date: Fri, 26 Oct 2012 21:37:08 +0100
Message-ID: <87wqydx957.fsf@spindle.srvr.nix>
References: <87objupjlr.fsf@spindle.srvr.nix>
	<20121023013343.GB6370@fieldses.org> <87mwzdnuww.fsf@spindle.srvr.nix>
	<20121023143019.GA3040@fieldses.org>
	<874nllxi7e.fsf_-_@spindle.srvr.nix>
	<87pq48nbyz.fsf_-_@spindle.srvr.nix> <508AF3FA.4020506@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: "Ted Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"J. Bruce Fields" <bfields@fieldses.org>,
	Bryan Schumaker <bjschuma@netapp.com>,
	Peng Tao <bergwolf@gmail.com>, Trond.Myklebust@netapp.com,
	gregkh@linuxfoundation.org, linux-nfs@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <508AF3FA.4020506@redhat.com> (Eric Sandeen's message of "Fri, 26
	Oct 2012 15:35:06 -0500")
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 26 Oct 2012, Eric Sandeen outgrape:

> On 10/23/12 3:57 PM, Nix wrote:
>> The only unusual thing about the filesystems on this machine are that
>> they have hardware RAID-5 (using the Areca driver), so I'm mounting with
>> 'nobarrier': the full set of options for all my ext4 filesystems are:
>> 
>> rw,nosuid,nodev,relatime,journal_checksum,journal_async_commit,nobarrier,quota,
>> usrquota,grpquota,commit=30,stripe=16,data=ordered,usrquota,grpquota
>
> Out of curiosity, when I test log replay with the journal_checksum option, I
> almost always get something like:
>
> [  999.917805] JBD2: journal transaction 84121 on dm-1-8 is corrupt.
> [  999.923904] EXT4-fs (dm-1): error loading journal
>
> after a simulated crash & log replay.
>
> Do you see anything like that in your logs?

I'm not seeing any corrupt journals or abort messages at all. The
journal claims to be fine, but plainly isn't.

I can reproduce this on a small filesystem and stick the image somewhere
if that would be of any use to anyone. (If I'm very lucky, merely making
this offer will make the problem go away. :} )

-- 
NULL && (void)
