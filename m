From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: fstrim has no effect on a just-mounted filesystem
Date: Wed, 12 Mar 2014 13:42:24 +0000
Message-ID: <20140312134224.GB19635@redhat.com>
References: <20140311213932.GA19176@redhat.com>
 <531F8456.2020404@redhat.com>
 <20140311220013.GV1346@redhat.com>
 <531F8953.1030702@redhat.com>
 <20140311225932.GW1346@redhat.com>
 <20140311230715.GA19648@redhat.com>
 <531F97A8.2020905@redhat.com>
 <20140311233047.GX1346@redhat.com>
 <20140312100507.GA19635@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>, pbonzini@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37505 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753974AbaCLNm1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Mar 2014 09:42:27 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s2CDgQeK017297
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 12 Mar 2014 09:42:27 -0400
Content-Disposition: inline
In-Reply-To: <20140312100507.GA19635@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Well, it turns out that the bug is mine.

I had libguestfs trimming the wrong filesystem :-(

Anyway I can report that fstrim works reliably, virt-sparsify now
supports an --in-place option, the world is good.

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
virt-top is 'top' for virtual machines.  Tiny program with many
powerful monitoring features, net stats, disk stats, logging, etc.
http://people.redhat.com/~rjones/virt-top
