From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfstests and ext4
Date: Wed, 19 Nov 2014 07:28:18 +1100
Message-ID: <20141118202818.GP23575@dastard>
References: <CAH2r5murzVmOVnRchq=U-jx74U96g7N6Y42CW0iX4HKpWnbmxw@mail.gmail.com>
 <20141114000216.GN28565@dastard>
 <CAH2r5mvi2LijxWia2sCf+em7rfPtBn_fg6WKU=aftVUTuzXMgw@mail.gmail.com>
 <20141117203804.GO23575@dastard>
 <CAH2r5mti8hVXqmKu9kJg4Xk=5nkESCAQys1BFXhR6JSDVHOTEA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	fstests@vger.kernel.org
To: Steve French <smfrench@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAH2r5mti8hVXqmKu9kJg4Xk=5nkESCAQys1BFXhR6JSDVHOTEA@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Nov 17, 2014 at 08:35:39PM -0600, Steve French wrote:
> On Mon, Nov 17, 2014 at 2:38 PM, Dave Chinner <david@fromorbit.com> wrote:
> 
> > the other as a base64 encoded attachment so can't be quoted and
> > replied to easily. In future, can you send patches as separate
> > emails according to:
> 
> Yes.  WIll do.  It is a pain in test  VMs to setup git with gmail two
> phase authentication
> but doable if I set it up to send mail from a different host.

No need for that. Keep the xfstests source tree on your
laptop/workstation and do all your edits there. When you've done
that, simply rsync the tree to the test VM(s) and run "make; ./check
..." from the shell you are running in the test VM.

That way you can manage the code multiple test VMs run from a single
source tree, all in one location, and you don't have to worry about
setting up for mail, backups, losing changes because a test machine
crash ate your recent changes, accidentally sending changes are
root, etc...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
