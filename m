From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: fstrim has no effect on a just-mounted filesystem
Date: Tue, 11 Mar 2014 18:09:28 -0500
Message-ID: <531F97A8.2020905@redhat.com>
References: <20140311213932.GA19176@redhat.com> <531F8456.2020404@redhat.com> <20140311220013.GV1346@redhat.com> <531F8953.1030702@redhat.com> <20140311225932.GW1346@redhat.com> <20140311230715.GA19648@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Richard W.M. Jones" <rjones@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62960 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755547AbaCKXJa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Mar 2014 19:09:30 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s2BN9TFS011300
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 11 Mar 2014 19:09:30 -0400
In-Reply-To: <20140311230715.GA19648@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 3/11/14, 6:07 PM, Richard W.M. Jones wrote:

> I got it to work by using:
> 
> ----------------------------------------------------------------------
> set -e
> set -x
> trace-cmd record -e all fstrim /sysroot
> trace-cmd report
> ----------------------------------------------------------------------
> 
> The output is absolutely huge and I didn't capture it.

that's why I suggested a single tracepoint, rather than every tracepoint
in the kernel... ;)

oh wait, I didn't.  :/  argh sorry.

# trace-cmd record -e ext4_trim\* 

should do it.

> However just the act of doing the tracing *caused* the trim to happen
> properly in the underlying disk.

that sounds very strange...

-Eric
 
> Rich.
> 

