From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [v2] ext4: fix possible non-initialized variable
Date: Tue, 18 Sep 2012 09:51:55 -0300
Message-ID: <20120918125155.GA30408@andromeda.usersys.redhat.com>
References: <1347314148-17463-1-git-send-email-cmaiolino@redhat.com>
 <20120915183023.GA9895@thunk.org>
 <505739F8.9050305@redhat.com>
 <50574226.3020908@redhat.com>
 <20120917153701.GA5510@thunk.org>
 <20120917182604.GA1959@andromeda.usersys.redhat.com>
 <20120918035931.GB32195@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8115 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932097Ab2IRMv6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Sep 2012 08:51:58 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q8ICpwQl004923
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 18 Sep 2012 08:51:58 -0400
Received: from andromeda.usersys.redhat.com (vpn1-7-14.gru2.redhat.com [10.97.7.14])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q8ICptSx026267
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 18 Sep 2012 08:51:58 -0400
Content-Disposition: inline
In-Reply-To: <20120918035931.GB32195@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 17, 2012 at 11:59:31PM -0400, Theodore Ts'o wrote:
> On Mon, Sep 17, 2012 at 03:26:04PM -0300, Carlos Maiolino wrote:
> > 
> > based on this conversation, is there anything else I should do to have this
> > patch accepted?
> 
> OK, I've applied this patch to my tree.  However, I would really
> appreciate if you could indeed review the callers for ext4_bread() and
> ext3_bread() and send patches for ext3 and ext4 as you have suggested,
> thanks!!
> 
On my todo list.
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
--Carlos
