From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [v2] ext4: fix possible non-initialized variable
Date: Wed, 19 Sep 2012 21:59:04 -0500
Message-ID: <505A8678.4060402@redhat.com>
References: <1347314148-17463-1-git-send-email-cmaiolino@redhat.com> <20120915183023.GA9895@thunk.org> <505739F8.9050305@redhat.com> <50574226.3020908@redhat.com> <20120917153701.GA5510@thunk.org> <20120917182604.GA1959@andromeda.usersys.redhat.com> <20120918035931.GB32195@thunk.org> <20120918125155.GA30408@andromeda.usersys.redhat.com> <20120919201057.GA23237@andromeda.usersys.redhat.com> <20120919204100.GF28470@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751929Ab2ITC7J (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Sep 2012 22:59:09 -0400
In-Reply-To: <20120919204100.GF28470@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 9/19/12 3:41 PM, Theodore Ts'o wrote:
> On Wed, Sep 19, 2012 at 05:10:57PM -0300, Carlos Maiolino wrote:
>> Ted,
>>
>> In case of ext4_add_entry() I'm supposing to make the function call ext4_error()
>> and return -EIO in the case where ext4_bread() returns NULL and err is 0'ed,
>> does that matches with your thoughts or is there a better way to handle with
>> this?
> 
> Yeah, that's about it.  The real issue is EIO isn't really the right
> errno code, but we don't have a better one.  I've considered trying to
> propose adding a new EFSCORRUPT errno value, just so that the error
> message that eventually gets displayed back to the user via an
> application error message is more obvious, but I haven't had the
> energy to see if we can get it past the fsdevel shed-painting
> process.

FWIW, xfs used to have a custom "EFSCORRUPTED" errno, but we ditched in
favor of a standard but seldom-used "EUCLEAN" (structure needs cleaning).
Doesn't seem like too bad a choice.

-Eric

>> I'm talking about ext4_add_entry() behavious mainly as an example to
>> better understand how we should handle these situations. In case of
>> ext4_add_entry(), based on our discussions ext4_bread() should not
>> fail once dir entries should not have HOLES, so, a NULL return
>> should indicate a on-disk corruption or an I/O error.
> 
> Well, a NULL return indicates that there is a hole in that particular
> inode.  If err=0, then it's a hole.  Whether or not a hole is an
> actual file system corruption is up to the caller of ext4_bread() to
> determine.  In the case of directories, holes are an example file
> system corruption, so for the code in fs/ext4/namei.c, the appropriate
> thing to do would be to call ext4_error() and then return an error to
> abort the operation.
> 
> There is an argument to be made that if the file system is mounted
> with errors=continue, in this case we could just try to ignore the
> hole, and try to recover as best we can.  But that's going to be quite
> tricky to implement, and I'm not at all convinced it's worth the extra
> complexity to implement.  I could imagine someone who had a very high
> requirement for "zero downtime" who might argue for this, but then we
> would need to make sure the fallback code really was bulletproof.  If
> we pursued this option, then the EIO or EFSCORRUPT error code would
> only be returned in the errors=remount-ro case.
> 
> (This is the sort of thing which is what customers pay $$$ for IBM's
> mainframe in zOS.  Whether or not this is really needed for ext4 and
> Linux, even for an enterprise product, is a different sort of
> question.  I wouldn't object to someone who tried to make the
> errors=continue behaviour to recover in a clean and safe way, but the
> code would have to be very clearly documented, tested, and carefully
> reviewed.)
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

