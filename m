From: Josh Triplett <josh@joshtriplett.org>
Subject: Re: NULL pointer dereference in ext4_superblock_csum_set with
 mounted filesystem
Date: Thu, 14 Mar 2013 10:42:16 -0700
Message-ID: <20130314174216.GA2981@jtriplet-mobl1>
References: <20130313185911.GA1446@jtriplet-mobl1>
 <20130313190141.GF5604@thunk.org>
 <20130313191016.GA1793@jtriplet-mobl1>
 <20130314040835.GB11821@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130314040835.GB11821@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Mar 14, 2013 at 12:08:35AM -0400, Theodore Ts'o wrote:
> Huh.  This is very, very weird.  Is this a repeatable crash?

I could reliably replicate it for that particular session, but now that
I've rebooted the host, no.

- Josh Triplett
