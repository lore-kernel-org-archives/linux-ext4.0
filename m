From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: howto downgrade ext4 to ext3
Date: Tue, 22 Sep 2009 10:33:33 -0500
Message-ID: <4AB8EE4D.8050705@redhat.com>
References: <4AB39EC5.6070107@it-sudparis.eu> <20090918175851.GH26991@mit.edu> <4AB3D060.2020101@redhat.com> <20090918193456.GA27303@mit.edu> <4AB3F9C4.1010702@it-sudparis.eu> <20090918225834.GC28781@mit.edu> <4AB53F3E.4040007@it-sudparis.eu> <4AB581EF.7050701@redhat.com> <4AB8EDBA.1080108@it-sudparis.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: jehan.procaccia@it-sudparis.eu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20969 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756594AbZIVPeS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Sep 2009 11:34:18 -0400
In-Reply-To: <4AB8EDBA.1080108@it-sudparis.eu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

jehan procaccia wrote:

...

> I had the time to experiment an ext4 FS mounted with -nodelalloc, and 
> now quotas seems to work fine with it ;-) .

...

> I will announce a maintenance on that server in order to remount  my 12 
> x 200GB partitions with -nodelalloc, if ever performances drops too much 
> , then I'll probably choose to set quotas off until a redhat kernel 
> package provides a solution .
> 
> does 2.6.31 already patche to deal correclty with delalloc and quotas ?

Mostly fixed in .31, although there is a recent thread on this list,
"ext4+quota+nfs issue"

For your purposes, I expect this will all get sorted out by RHEL5.5's
time :)

-Eric

> Thanks .
> 

