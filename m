From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] ext4: ext4_bread usage audit
Date: Wed, 26 Sep 2012 11:14:17 -0300
Message-ID: <20120926141417.GA3485@andromeda.usersys.redhat.com>
References: <1348512100-23323-1-git-send-email-cmaiolino@redhat.com>
 <20120926034240.GE11468@thunk.org>
 <50627B01.6070306@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27520 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755760Ab2IZOyb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Sep 2012 10:54:31 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q8QEsVXQ029638
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 26 Sep 2012 10:54:31 -0400
Received: from andromeda.usersys.redhat.com (ovpn-113-142.phx2.redhat.com [10.3.113.142])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q8QEEHUJ014308
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 26 Sep 2012 10:14:20 -0400
Content-Disposition: inline
In-Reply-To: <50627B01.6070306@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 25, 2012 at 10:48:17PM -0500, Eric Sandeen wrote:
> On 9/25/12 10:42 PM, Theodore Ts'o wrote:
> > On Mon, Sep 24, 2012 at 03:41:40PM -0300, Carlos Maiolino wrote:
> >>
> >> Some ext4_bread callers do not needed any changes either because they already
> >> had its own hole detector paths or because these are deprecaded (like
> >> dx_show_entries)
> > 
> > BTW, dx_show entries isn't really deprecated; is debugging code which
> > is usually not compiled in, but it does get used from time to time by
> > developers who are debugging the directory hash tree code...
> > 
> > So having it show the holes by printing a note that there _was_ a
> > whole is probably a good thing from a debugging point of view...
> 
> I think what Carlos meant is that there are no callers in the tree...
> so even with debug options, it's not used.  It takes a custom patch...
> Does it still work? :)
> 
Yeah, that's what I meant, no callers of dx_show_entries() even with debug
enabled.

In regards to the coding style of if conditionals, I just followed the coding
style of most places in the code, I also changed some of the if conditionals to
match the rest of the code. i.e.:

if(!(bh = ext4_bread())) {
	do_something();
}

if you take a look at the code, most if conditionals regarding the calls to
ext4_bread() are in the above coding style. I just followed it, but, I'm not
against change that to another one, but agree the above looks better and save
some code lines
> -Eric
> 
> >       	 	    	       - Ted
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
