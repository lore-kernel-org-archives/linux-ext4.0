From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [v2] ext4: fix possible non-initialized variable
Date: Fri, 21 Sep 2012 16:14:49 -0300
Message-ID: <20120921191449.GA18336@andromeda.usersys.redhat.com>
References: <20120915183023.GA9895@thunk.org>
 <505739F8.9050305@redhat.com>
 <50574226.3020908@redhat.com>
 <20120917153701.GA5510@thunk.org>
 <20120917182604.GA1959@andromeda.usersys.redhat.com>
 <20120918035931.GB32195@thunk.org>
 <20120918125155.GA30408@andromeda.usersys.redhat.com>
 <20120919201057.GA23237@andromeda.usersys.redhat.com>
 <20120919204100.GF28470@thunk.org>
 <505A8678.4060402@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37783 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756608Ab2IUTOy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Sep 2012 15:14:54 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q8LJEsO3014204
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Fri, 21 Sep 2012 15:14:54 -0400
Received: from andromeda.usersys.redhat.com (ovpn-113-28.phx2.redhat.com [10.3.113.28])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q8LJEoax009305
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 21 Sep 2012 15:14:53 -0400
Content-Disposition: inline
In-Reply-To: <505A8678.4060402@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 19, 2012 at 09:59:04PM -0500, Eric Sandeen wrote:
> On 9/19/12 3:41 PM, Theodore Ts'o wrote:
> > On Wed, Sep 19, 2012 at 05:10:57PM -0300, Carlos Maiolino wrote:
> >> Ted,
> >>
> >> In case of ext4_add_entry() I'm supposing to make the function call ext4_error()
> >> and return -EIO in the case where ext4_bread() returns NULL and err is 0'ed,
> >> does that matches with your thoughts or is there a better way to handle with
> >> this?
> > 
> > Yeah, that's about it.  The real issue is EIO isn't really the right
> > errno code, but we don't have a better one.  I've considered trying to
> > propose adding a new EFSCORRUPT errno value, just so that the error
> > message that eventually gets displayed back to the user via an
> > application error message is more obvious, but I haven't had the
> > energy to see if we can get it past the fsdevel shed-painting
> > process.
> 
> FWIW, xfs used to have a custom "EFSCORRUPTED" errno, but we ditched in
> favor of a standard but seldom-used "EUCLEAN" (structure needs cleaning).
> Doesn't seem like too bad a choice.
> 
> -Eric
> 
Not a bad idea really.

I've found some functions properly handling the problem (i.e !bh and !err), but
some of them not. I'm thinking in fix functions with missing hole handlers and
after that think about a 'default directory hole handler' for this, instead of
make each function work on a specific way.

What you guys think?
> >> I'm talking about ext4_add_entry() behavious mainly as an example to
> >> better understand how we should handle these situations. In case of
> >> ext4_add_entry(), based on our discussions ext4_bread() should not
> >> fail once dir entries should not have HOLES, so, a NULL return
> >> should indicate a on-disk corruption or an I/O error.
> > 
> > Well, a NULL return indicates that there is a hole in that particular
> > inode.  If err=0, then it's a hole.  Whether or not a hole is an
> > actual file system corruption is up to the caller of ext4_bread() to
> > determine.  In the case of directories, holes are an example file
> > system corruption, so for the code in fs/ext4/namei.c, the appropriate
> > thing to do would be to call ext4_error() and then return an error to
> > abort the operation.
> > 
> > There is an argument to be made that if the file system is mounted
> > with errors=continue, in this case we could just try to ignore the
> > hole, and try to recover as best we can.  But that's going to be quite
> > tricky to implement, and I'm not at all convinced it's worth the extra
> > complexity to implement.  I could imagine someone who had a very high
> > requirement for "zero downtime" who might argue for this, but then we
> > would need to make sure the fallback code really was bulletproof.  If
> > we pursued this option, then the EIO or EFSCORRUPT error code would
> > only be returned in the errors=remount-ro case.
> > 
> > (This is the sort of thing which is what customers pay $$$ for IBM's
> > mainframe in zOS.  Whether or not this is really needed for ext4 and
> > Linux, even for an enterprise product, is a different sort of
> > question.  I wouldn't object to someone who tried to make the
> > errors=continue behaviour to recover in a clean and safe way, but the
> > code would have to be very clearly documented, tested, and carefully
> > reviewed.)
> > 
> > 						- Ted
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
--Carlos
