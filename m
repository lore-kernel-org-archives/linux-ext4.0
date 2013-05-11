From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v2] jbd2: Fix block tag checksum verification brokenness
Date: Sat, 11 May 2013 01:14:32 +0100
Message-ID: <20130511001432.GO25399@ZenIV.linux.org.uk>
References: <20130510233807.GB5706@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130510233807.GB5706@blackbox.djwong.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, May 10, 2013 at 04:38:07PM -0700, Darrick J. Wong wrote:
> Al Viro complained of a ton of bogosity with regards to the jbd2 block tag
> header checksum.  This one checksum is 16 bits, so cut off the upper 16 bits
> and treat it as a 16-bit value and don't mess around with be32* conversions.
> Fortunately metadata checksumming is still "experimental" and not in a shipping
> e2fsprogs, so there should be few users affected by this.
> 
> v2: Eliminate unnecessary variables and make it clear(er) which values are 32
> bits wide.
> 
> Reported-by: Al Viro <viro@ZenIV.linux.org.uk>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

ACKed-by: Al Viro <viro@ZenIV.linux.org.uk>
