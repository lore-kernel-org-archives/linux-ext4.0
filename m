From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Legal characters in encrypted fscrypto (f2fs/ext4)
	filename?
Date: Fri, 1 Apr 2016 02:21:21 -0400
Message-ID: <20160401062121.GC29897@thunk.org>
References: <20160401060018.GD1323@zzz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: mhalcrow@google.com, linux-kernel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-fsdevel@vger.kernel.org, jaegeuk@kernel.org,
	linux-ext4@vger.kernel.org
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20160401060018.GD1323@zzz>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

On Fri, Apr 01, 2016 at 01:00:18AM -0500, Eric Biggers wrote:
> Hello,
> 
> While reviewing the new filesystem encryption code, I was confused by the
> intended set of legal characters in the printable form of an encrypted filename.
> 
> According to the actual code in fs/crypto/fname.c, the legal characters are:
> 
> 	a-zA-Z0-9+,

It's not really a question of "legality".  Rather, the base-64
encoding that we use is merely a presentation layer issue.  It's
really an implementation detail that does not affect the on-disk
encoding, and so in fact, it can be changed in different kernel
versions since the "encrypted filename" is essentially a cookie which
is presented to the user via readdir(), and which the user can then
send back to the kernel using, say, the unlink() system call.

It's changed over time to avoid potential confusion --- for example
the traditional base-64 encoding uses a-zA-Z0-9+/ --- but the use of
'/' causes problem because it's the pathname separator.

The fact that the design doc and comments are out of date is
unfortunate, but ultimately, it really doesn't matter.  

> Alternatively, according to the comment in the same file, the legal characters
> are actually:
> 
> 	a-zA-Z0-9+_
> 
> Still alternatively, according to the design document[1], the legal characters
> are actually:
> 
> 	a-zA-Z0-9+=

As I recall the equals sign could cause problems with shell scripts.
I don't remember the objection to the underscore character.

If you wanted to patch the kernel so that on your system, you used
a-ZA-Z0-9^@, you wouldn't break compatibility or interoperability.  So
there really isn't any such thing as "correct".

Cheers,

  	  		     	       - Ted
			       

------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785471&iu=/4140
