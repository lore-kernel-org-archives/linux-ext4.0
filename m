From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Date: Tue, 20 May 2008 08:04:48 -0400
Message-ID: <200805200804.49389.chris.mason@oracle.com>
References: <482DDA56.6000301@redhat.com> <200805192029.21688.chris.mason@oracle.com> <48324598.4060803@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	Eric Sandeen <sandeen@redhat.com>,
	Theodore Tso <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Timothy Shimmin <tes@sgi.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <48324598.4060803@sgi.com>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Monday 19 May 2008, Timothy Shimmin wrote:

[ power fail testing with write back cache on ]

> > I was also able to trigger corruptions on XFS (one run out of two), so it
> > is unlikely I'm seeing bugs in the ext3 replay or logging code.
>
> Just to clarify,
> was this test with barriers on or off for XFS?
> I'm wondering if it was with barriers on, then we have a reproducible
> bug in log replay.
> Or whether you were just confirming the problems with barriers off on
> another filesystem.

Barriers were off on xfs, the corruptions were not xfs' fault.

-chris
