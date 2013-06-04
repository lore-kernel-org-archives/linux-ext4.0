From: "George Spelvin" <linux@horizon.com>
Subject: Re: [PATCH v3] jbd2: Fix block tag checksum verification brokenness
Date: 3 Jun 2013 23:32:08 -0400
Message-ID: <20130604033208.32486.qmail@science.horizon.com>
References: <20130604004015.GA6087@blackbox.djwong.org>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: darrick.wong@oracle.com, linux@horizon.com, tytso@mit.edu
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20130604004015.GA6087@blackbox.djwong.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jun 03, 2013 at 12:55:21AM -0700, Darrick J. Wong wrote:
> Drat, I was writing this email too late at night.  There /is/ a related
> e2fsprogs patch for this:
> http://comments.gmane.org/gmane.comp.file-systems.ext4/38621

> Hey Ted, any thoughts on this jbd2/e2fsprogs patch pair?  Al acked the jbd2
> part.

He's already pulled it into ext4/dev (eee06c56).  I've been watching
it because an earlier version (which got merged into 3.10-rc1) has
an essential fix to update extent block checksums properly during
defragmentation.

I just have to be careful not to pull the *current* ext4/dev or I'll
break things.  :-(
