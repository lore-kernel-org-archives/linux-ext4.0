From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Possible ext4 corruption - ACL related?
Date: Mon, 09 Mar 2009 23:35:10 -0500
Message-ID: <49B5EDFE.8060405@redhat.com>
References: <1236642197.30280.18.camel@kulgan.wumi.org.au>	 <49B5D71D.1030802@redhat.com> <1236655451.30280.29.camel@kulgan.wumi.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Kevin Shanahan <kmshanah@ucwb.org.au>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:38068 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395AbZCJEfV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Mar 2009 00:35:21 -0400
In-Reply-To: <1236655451.30280.29.camel@kulgan.wumi.org.au>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Kevin Shanahan wrote:
> On Mon, 2009-03-09 at 21:57 -0500, Eric Sandeen wrote:
>> Kevin Shanahan wrote:
...
>> If you try a manual getfacl of the above files do you still get the error?
> 
> Yeah, same thing:
> 
> hermes:/srv/samba/local# getfacl apps/Gestalt.Net/SetupCD/program\ files/Business\ Objects/Common/3.5/bin/Cdo32sv.dll 
> getfacl: apps/Gestalt.Net/SetupCD/program\040files/Business\040Objects/Common/3.5/bin/Cdo32sv.dll: Input/output error
> 
> Nothing extra showing up in dmesg after doing that, so it's possible the
> two are unrelated - although, the coincidence would surprise me.

Can you try debugfs /dev/whatever, and then do:

debugfs> stat
apps/Gestalt.Net/SetupCD/program\040files/Business\040Objects/Common/3.5/bin/Cdo32sv.dll

(all one line there, and this is assuming that apps/ is the root dir on
that filesystem, if not adjust accordingly...)

-Eric
