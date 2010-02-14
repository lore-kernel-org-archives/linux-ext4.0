From: tytso@mit.edu
Subject: Re: Extents in spare files on ext4 not being merged
Date: Sun, 14 Feb 2010 13:03:39 -0500
Message-ID: <20100214180339.GH5337@thunk.org>
References: <b3f268591002140550x746b96aeo3c7a017ac4ecf993@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Jari Sundell <sundell.software@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <b3f268591002140550x746b96aeo3c7a017ac4ecf993@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Feb 14, 2010 at 10:50:45PM +0900, Jari Sundell wrote:
> http://libtorrent.rakshasa.no/ticket/460#comment:49
> 
> Some users of rtorrent reported very high number of extents for files
> despite the use of posix_fallocate/fallocate on ext4. (3000+ for 250MB
> file, ) A test program showed that the file was contiguous on disk
> despite the high number of extents reported by filefrag. (Not sure
> what kernel versions they used)

Yeah, it's a known problem.  The main problem is that we are only
checking to see merge both to the left and the right of the extent
tree when converting an extent from uninitialzied to initialized.

I've cc'ed the linux-ext4 list in the hopes someone is motivated to
fix this long-standing shortcoming.  Unless someone starts working
quickly, it's not likely it will make this upcoming merge window, but
we can hope....

						- Ted
