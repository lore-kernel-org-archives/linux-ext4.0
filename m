From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Atomic non-durable file write API
Date: Sun, 26 Dec 2010 20:04:34 -0500
Message-ID: <20101227010434.GG2595@thunk.org>
References: <20101225031529.GA2595@thunk.org>
 <AANLkTi=TWjKMfLG0nGGjxvGR87PwNm5NkKYPnsFsLgfZ@mail.gmail.com>
 <AANLkTikHMZDyNkaOux5VWUHvC5D1cXHEFKxhvzfVjN+Q@mail.gmail.com>
 <AANLkTinjtoF0gOdi6TV+RPjMkeqA8fcrkJBYRBd5WQ==@mail.gmail.com>
 <AANLkTi=g4zvxdQdnS7crg015sexk3NSJ3CaODi_c=6Fv@mail.gmail.com>
 <AANLkTinHa1wLB6hKi_xwiQNwMb1xZs-pa1sLB=ebtjiX@mail.gmail.com>
 <AANLkTinXd8Zf=13HSYTxsAUc02jbCgV=17UqXQyFxNUG@mail.gmail.com>
 <AANLkTi=ihgiJAsJ+hSeRjhcOTUhY5YC-xPDRPT0ws+oB@mail.gmail.com>
 <20101226221016.GF2595@thunk.org>
 <4D17DE0D.2070504@ontolinux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org,
	Olaf van der Spek <olafvdspek@gmail.com>,
	Nick Piggin <npiggin@gmail.com>
To: Christian Stroetmann <stroetmann@ontolinux.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D17DE0D.2070504@ontolinux.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Dec 27, 2010 at 01:30:05AM +0100, Christian Stroetmann wrote:
> An FS could easily have the rest of the functions of a database
> management system (DBMS) as an FSDB, a hybrid if you wish. An
> example for such a hybrid is the ext2/3-sqlite FS...

What are you talking about?  If you mean creating a sqlite database on
top of an existing file system, sure that works fine.  That's the
right solution.  But if you mean trying to access sqllite via a
file-system interface (i.e., via FUSE), I suspect the result will be a
disaster, precisely because the file system API isn't expressive
enough to handle database functionality, and so the result ends up
being a performance disaster.  So the answer is "use a database, using
a database API, if you have database requirements".

> Furthermore, the performance of Oracle's solutions was and still is
> so low, because they have a file system as a database that is
> managed by a DBMS as a file that again is stored in an FS. Can you
> see now what does the loss of performance?

It was a disaster from a performance perspective even if the database
was run on top of a raw block device....

> And Oracle fears FSs like R4 that have database(-like)
> functionalities, so it took those technical features of R4 for the
> BTRFS, which they thought could stop its show.
> And also, Oracle has started some months ago again to promote its FS
> in a DB in an FS concept.

I've never heard of the R4 file system, and apparently Google hasn't
either.  But if you think BTRFS is a database, you're fooling
yourself.  There's a lot more to a database than just using a b-tree.

> So, there must be something that is highly interesting with the idea
> to use an FS as DBMS, not only for Oracle, but at least for the four
> largest software companies.

No, I think you're just utterly confused from a technical perspective.

      	    	   			      - Ted
