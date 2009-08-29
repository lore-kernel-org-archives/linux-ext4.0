From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Data integrity built into the storage stack [was: Re: [testcase] test
	your fs/storage stack (was Re: [patch] ext2/3: document conditions when
	reliable operation is possible)]
Date: Sat, 29 Aug 2009 17:23:50 -0400
Message-ID: <87f94c370908291423ub92922ft2cceab9e34ac6207@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Pavel Machek <pavel@ucw.cz>, Ric Wheeler <rwheeler@redhat.com>,
	Theodore Tso <tytso@mit.edu>, Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.net>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net,
	"Martin K. Petersen" <martin.petersen@oracle.com>
To: david@lang.hm
Return-path: <linux-doc-owner@vger.kernel.org>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I've read a fair amount of the various threads discussing sector /
data corruption of flash and raid devices, but by no means all.

It seems to me the key thing Pavel is highlighting is that many
storage devices / arrays have reasonably common failure modes where
data corruption is silently introduced to stable data.  I have seen it
mentioned, but the scsi spec. recently got a "data integrity" option
that would allow these corruptions to at least be detected if the
option were in use.

Regardless, administrators have known forever that a bad cable / bad
ram / bad controller / etc. can cause data written to a hard drive to
be written with corrupted values that will not cause a media error on
read.

But most of us assume once we get data on a storage medium and verify
it, we can read it at some future point and it will either have the
correct data values, or it will have a media error.  If there is a
media error we know to get out our backups.

The scary aspect of this to me is that with the failure modes Pavel
has brought up, valid data is being written to the storage medium.  It
can be verified via hash, etc.  But then at some point in the future,
the data can just change in a more or less random way even though it
is not being modified / overwritten.

I think a good phrase to describe this is "silent corruption of stable
data on a permanent storage medium".  I'm sure that silent data
corruption can happen on a traditional harddrive, but I suspect the
odds are so slim most of us won't encounter it in a lifetime.  The
failure modes Pavel is describing seem much more common, and I for one
was not familiar with them prior to this set of threads starting.

It seems to me a file system neutral document describing "silent
corruption of stable data on permanent storage medium" would be
appropriate.   Then the linux kernel can start to be hardened to
properly respond to situations where the data read is not the data
written.

We already have the scsi data integrity patches that went in last
winter and I believe fit into the storage stack below the filesystem
layer.

I don't believe most of the storage stack has been modified to
 add any data integrity features that would help to ensure the data
read is the data written, but this whole series of threads highlights
to me that a significant effort should go into increasing the data
integrity capability of the linux storage stack.

I do believe there is a patch floating around for device mapper to add
some integrity capability.

Greg
-- 
Greg Freemyer
Head of EDD Tape Extraction and Processing team
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
Preservation and Forensic processing of Exchange Repositories White Paper -
<http://www.norcrossgroup.com/forms/whitepapers/tng_whitepaper_fpe.html>

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
