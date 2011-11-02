From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH -next] ext4: fix printk format warning in page-io
Date: Tue, 1 Nov 2011 21:59:29 -0400
Message-ID: <20111102015929.GP32161@thunk.org>
References: <20111101205323.c12f2f940f23febba8ab8989@canb.auug.org.au>
 <4EB08189.2@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Linus <torvalds@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4EB08189.2@xenotime.net>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Nov 01, 2011 at 04:32:25PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> Fix printk format warning:
> 
> fs/ext4/page-io.c:108:5: warning: format '%d' expects type 'int', but argument 6 has type 'ssize_t'
> 
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> Cc:	"Theodore Ts'o" <tytso@mit.edu>
> Cc:	Andreas Dilger <adilger.kernel@dilger.ca>
> Cc:	linux-ext4@vger.kernel.org

Thanks, I'll get this fixed before I send my pull request.

	     	      	    	     	  - Ted
