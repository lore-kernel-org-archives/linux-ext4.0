From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/1] ext2: Add __init macro to init_inodecache
Date: Sat, 1 Feb 2014 10:53:34 -0700
Message-ID: <20140201175334.GJ20939@parisc-linux.org>
References: <20140201160202.a3ac96c613754013300b462d@skynet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, jack@suse.cz,
	linux-ext4@vger.kernel.org
To: Fabian Frederick <fabf@skynet.be>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140201160202.a3ac96c613754013300b462d@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Feb 01, 2014 at 04:02:02PM +0800, Fabian Frederick wrote:
> init_inodecache is only called by __init init_ext2_fs.

Looks like this is true for the majority of filesystems.  Would you care
to submit more patches?  :-)

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
