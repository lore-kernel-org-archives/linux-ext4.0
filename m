From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfstests and ext4
Date: Wed, 19 Nov 2014 11:07:25 -0800
Message-ID: <20141119190725.GA6264@infradead.org>
References: <CAH2r5murzVmOVnRchq=U-jx74U96g7N6Y42CW0iX4HKpWnbmxw@mail.gmail.com>
 <20141114000216.GN28565@dastard>
 <CAH2r5mvi2LijxWia2sCf+em7rfPtBn_fg6WKU=aftVUTuzXMgw@mail.gmail.com>
 <20141117203804.GO23575@dastard>
 <CAH2r5mti8hVXqmKu9kJg4Xk=5nkESCAQys1BFXhR6JSDVHOTEA@mail.gmail.com>
 <20141118202818.GP23575@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steve French <smfrench@gmail.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	fstests@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141118202818.GP23575@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Nov 19, 2014 at 07:28:18AM +1100, Dave Chinner wrote:
> No need for that. Keep the xfstests source tree on your
> laptop/workstation and do all your edits there. When you've done
> that, simply rsync the tree to the test VM(s) and run "make; ./check
> ..." from the shell you are running in the test VM.
> 
> That way you can manage the code multiple test VMs run from a single
> source tree, all in one location, and you don't have to worry about
> setting up for mail, backups, losing changes because a test machine
> crash ate your recent changes, accidentally sending changes are
> root, etc...

Or commit them to a local git branch that you can pull from the VMs
instead of the rsync.  The effect is the same, though.

