From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [v2] ext4: fix possible non-initialized variable
Date: Wed, 19 Sep 2012 17:10:57 -0300
Message-ID: <20120919201057.GA23237@andromeda.usersys.redhat.com>
References: <1347314148-17463-1-git-send-email-cmaiolino@redhat.com>
 <20120915183023.GA9895@thunk.org>
 <505739F8.9050305@redhat.com>
 <50574226.3020908@redhat.com>
 <20120917153701.GA5510@thunk.org>
 <20120917182604.GA1959@andromeda.usersys.redhat.com>
 <20120918035931.GB32195@thunk.org>
 <20120918125155.GA30408@andromeda.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751454Ab2ISULD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Sep 2012 16:11:03 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q8JKB3bh007018
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 19 Sep 2012 16:11:03 -0400
Received: from andromeda.usersys.redhat.com (vpn1-7-46.gru2.redhat.com [10.97.7.46])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q8JKAwxX023064
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 19 Sep 2012 16:11:02 -0400
Content-Disposition: inline
In-Reply-To: <20120918125155.GA30408@andromeda.usersys.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> > OK, I've applied this patch to my tree.  However, I would really
> > appreciate if you could indeed review the callers for ext4_bread() and
> > ext3_bread() and send patches for ext3 and ext4 as you have suggested,
> > thanks!!
> > 
> On my todo list.
> > 						- Ted
Ted,

In case of ext4_add_entry() I'm supposing to make the function call ext4_error()
and return -EIO in the case where ext4_bread() returns NULL and err is 0'ed,
does that matches with your thoughts or is there a better way to handle with
this?
I'm talking about ext4_add_entry() behavious mainly as an example to better
understand how we should handle these situations. In case of ext4_add_entry(),
based on our discussions ext4_bread() should not fail once dir entries should
not have HOLES, so, a NULL return should indicate a on-disk corruption or an I/O
error.

Does that makes sense?

-- 
--Carlos
