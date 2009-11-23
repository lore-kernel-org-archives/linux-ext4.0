From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: i_version, NFSv4 change attribute
Date: Mon, 23 Nov 2009 11:59:07 -0500
Message-ID: <20091123165907.GC3292@fieldses.org>
References: <20091122222047.GB21944@fieldses.org> <20091123114831.GA2532@thunk.org> <20091123164445.GB3292@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20091123164445.GB3292@fieldses.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Nov 23, 2009 at 11:44:45AM -0500, J. Bruce Fields wrote:
> If the side we want to optimize is the modifications, I wonder if we
> could do all the i_version increments on *read* of i_version?:
> 
> 	- writes (and other inode modifications) set an "i_version_dirty"
> 	  flag.
> 	- reads of i_version clear the i_version_dirty flag, increment
> 	  i_version, and return the result.
> 
> As long as the reader sees i_version_flag set only after it sees the
> write that caused it, I think it all works?

Except I'm a little confused about how i_version behaves (and should
behave) on reboot.  Assuming it's currently correct, I think it's enough
to also increment i_version as above when writing out the inode.

--b.
