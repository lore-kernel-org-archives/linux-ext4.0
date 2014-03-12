From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: fstrim has no effect on a just-mounted filesystem
Date: Wed, 12 Mar 2014 18:24:16 +0000
Message-ID: <20140312182416.GB1346@redhat.com>
References: <20140311213932.GA19176@redhat.com>
 <531F8456.2020404@redhat.com>
 <20140311220013.GV1346@redhat.com>
 <531F8953.1030702@redhat.com>
 <20140311225932.GW1346@redhat.com>
 <20140311230715.GA19648@redhat.com>
 <531F97A8.2020905@redhat.com>
 <20140311233047.GX1346@redhat.com>
 <20140312100507.GA19635@redhat.com>
 <5320A322.7020009@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45010 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429AbaCLSYT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Mar 2014 14:24:19 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s2CIOHBw011821
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 12 Mar 2014 14:24:18 -0400
Content-Disposition: inline
In-Reply-To: <5320A322.7020009@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 12, 2014 at 07:10:42PM +0100, Paolo Bonzini wrote:
> Il 12/03/2014 11:17, Richard W.M. Jones ha scritto:
> >Somewhere, the discard requests are disappearing in the stack (or more
> >likely, being delayed).  blktrace/trace-cmd somehow forces them out.
> >But fsync/sync/umount/sleep does not.  They might be stuck in qemu too ...
> 
> No, this I can be quite sure about.  QEMU sends them as soon as they
> are received in the SCSI layer.  If they were ill-formed, QEMU would
> fail them.  If they got stuck, sooner or later you'd not be able to
> do I/O anymore (there is a queue depth limit) and the guest would
> start getting timeouts.
> 
> Also, certainly blktrace would have no effect on QEMU.

Yup, it was completely a bug at my end.  Now that is fixed,
fstrim works perfectly.

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming blog: http://rwmj.wordpress.com
Fedora now supports 80 OCaml packages (the OPEN alternative to F#)
