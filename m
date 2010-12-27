From: Christian Stroetmann <stroetmann@ontolinux.com>
Subject: Re: Atomic non-durable file write API
Date: Mon, 27 Dec 2010 02:30:15 +0100
Message-ID: <4D17EC27.4050808@ontolinux.com>
References: <20101225031529.GA2595@thunk.org> <AANLkTi=TWjKMfLG0nGGjxvGR87PwNm5NkKYPnsFsLgfZ@mail.gmail.com> <AANLkTikHMZDyNkaOux5VWUHvC5D1cXHEFKxhvzfVjN+Q@mail.gmail.com> <AANLkTinjtoF0gOdi6TV+RPjMkeqA8fcrkJBYRBd5WQ==@mail.gmail.com> <AANLkTi=g4zvxdQdnS7crg015sexk3NSJ3CaODi_c=6Fv@mail.gmail.com> <AANLkTinHa1wLB6hKi_xwiQNwMb1xZs-pa1sLB=ebtjiX@mail.gmail.com> <AANLkTinXd8Zf=13HSYTxsAUc02jbCgV=17UqXQyFxNUG@mail.gmail.com> <AANLkTi=ihgiJAsJ+hSeRjhcOTUhY5YC-xPDRPT0ws+oB@mail.gmail.com> <20101226221016.GF2595@thunk.org> <4D17DE0D.2070504@ontolinux.com> <20101227010434.GG2595@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org,
	Olaf van der Spek <olafvdspek@gmail.com>,
	Nick Piggin <npiggin@gmail.com>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:59571 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171Ab0L0B3z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 26 Dec 2010 20:29:55 -0500
In-Reply-To: <20101227010434.GG2595@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 27.12.2010 02:04, Ted Ts'o wrote:
> On Mon, Dec 27, 2010 at 01:30:05AM +0100, Christian Stroetmann wrote:
>> An FS could easily have the rest of the functions of a database
>> management system (DBMS) as an FSDB, a hybrid if you wish. An
>> example for such a hybrid is the ext2/3-sqlite FS...
> What are you talking about?  If you mean creating a sqlite database on
> top of an existing file system, sure that works fine.

No, I don't mean this.

>    That's the
> right solution.  But if you mean trying to access sqllite via a
> file-system interface (i.e., via FUSE),

No, I don't mean this. I mean taking out the FUSE and do it directly.

>   I suspect the result will be a
> disaster, precisely because the file system API isn't expressive
> enough to handle database functionality, and so the result ends up
> being a performance disaster.

Three times wrong:
Firstly, the result won't be a disaster.
Secondly, I already said in the e-mail before that file system API will 
be extended by this additional database functionality, which is just 
only a little architectural problem.
Thirdly, it won't end up in a performance disaster.

>    So the answer is "use a database, using
> a database API, if you have database requirements".

No, I won't.

>> Furthermore, the performance of Oracle's solutions was and still is
>> so low, because they have a file system as a database that is
>> managed by a DBMS as a file that again is stored in an FS. Can you
>> see now what does the loss of performance?
> It was a disaster from a performance perspective even if the database
> was run on top of a raw block device....

Yes, for sure. So what?

>> And Oracle fears FSs like R4 that have database(-like)
>> functionalities, so it took those technical features of R4 for the
>> BTRFS, which they thought could stop its show.
>> And also, Oracle has started some months ago again to promote its FS
>> in a DB in an FS concept.
> I've never heard of the R4 file system, and apparently Google hasn't
> either.  But if you think BTRFS is a database, you're fooling
> yourself.  There's a lot more to a database than just using a b-tree.

I'm sorry, because I was really thinking that you do know that R4 is 
used as the short term for the file system Reiser4.
And no,  I'm not fooling, because I don't think that BTRFS is a 
database. I only said that Oracle took technical parts of Reiser4 like a 
b-tree datastructure and some other parts as a show stopper.

>> So, there must be something that is highly interesting with the idea
>> to use an FS as DBMS, not only for Oracle, but at least for the four
>> largest software companies.
> No, I think you're just utterly confused from a technical perspective.

No, I'm not utterly confused from a technical perspective. You really 
have a wrong impression.
And if you read above again, then you will see that I already said that 
Oracle has started once again the promotion of its concept with an FS in 
a DB in an FS (this thing that you described as a performance disaster 
even running on a raw block device). Do you claim that Oracle doesn't do 
this?
I'm sorry, but I do believe Oracle, Microsoft and Apple more than you.

>        	    	   			- Ted
>

Christian Stroetmann
