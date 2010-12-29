From: Dave Chinner <david@fromorbit.com>
Subject: Re: Atomic non-durable file write API
Date: Wed, 29 Dec 2010 22:05:36 +1100
Message-ID: <20101229110536.GA15179@dastard>
References: <AANLkTinXd8Zf=13HSYTxsAUc02jbCgV=17UqXQyFxNUG@mail.gmail.com>
 <AANLkTi=ihgiJAsJ+hSeRjhcOTUhY5YC-xPDRPT0ws+oB@mail.gmail.com>
 <20101226221016.GF2595@thunk.org>
 <AANLkTikS8hJtqxRrc3CqQs591bSkynQT1hg=vR4QBo0J@mail.gmail.com>
 <4D18B106.4010308@ontolinux.com>
 <AANLkTimMSxGTEcTbsx8MUYVTLhYRxrdDFQsi6Toer_h9@mail.gmail.com>
 <4D18E94C.3080908@ontolinux.com>
 <AANLkTikW8K4VFLJuYngU64m2vAL1yhA3R=jRt7U6-RRp@mail.gmail.com>
 <20101229075928.6bdafb08@notabene.brown>
 <AANLkTimxbjEntSBYxzxnHnOOCUkdNyGWJ40HGG=0d0E5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Neil Brown <neilb@suse.de>,
	Olaf van der Spek <olafvdspek@gmail.com>,
	Christian Stroetmann <stroetmann@ontolinux.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Ted Ts'o <tytso@mit.edu>,
	Nick Piggin <npiggin@gmail.com>
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTimxbjEntSBYxzxnHnOOCUkdNyGWJ40HGG=0d0E5@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Dec 28, 2010 at 05:00:55PM -0500, Greg Freemyer wrote:
> If I am working on a office doc with oowriter as an example, I don't
> want a system crash or out of diskspace to kill my original doc.  7 or
> 8 years ago XFS used to zero out the file in situations like that.

FUD. XFS has _never_ zeroed files during recovery. This gets repeated
often enough that we've even got a FAQ entry for it:

http://xfs.org/index.php/XFS_FAQ#Q:_Why_do_I_see_binary_NULLS_in_some_files_after_recovery_when_I_unplugged_the_power.3F

> Hopefully that's fixed.

4 years ago...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
