From: "U.Mutlu" <for-gmane@mutluit.com>
Subject: Re: Htree concept
Date: Wed, 13 May 2015 18:24:07 +0200
Message-ID: <mivtr7$jfq$1@ger.gmane.org>
References: <mivr40$2lj$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59193 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932183AbbEMQYR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 May 2015 12:24:17 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1YsZS9-0000Ek-9d
	for linux-ext4@vger.kernel.org; Wed, 13 May 2015 18:24:13 +0200
Received: from ip4d14ab60.dynamic.kabel-deutschland.de ([77.20.171.96])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Wed, 13 May 2015 18:24:13 +0200
Received: from for-gmane by ip4d14ab60.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Wed, 13 May 2015 18:24:13 +0200
In-Reply-To: <mivr40$2lj$1@ger.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

U.Mutlu wrote on 05/13/2015 05:37 PM:
> Hi,
> I'm writing a toy-fs, and discover a major shortcoming
> (finding a given child (dir/file) as fast as possible),
> which other developers (ie. ext3/4) had encountered long ago too.
> They introduced HTree. The info on HTree on the web is scarce
> or I couldn't find the right texts/papers yet.
> I wonder how HTree works on a conceptual basis.
> Could a kind soul enligten me pls. TIA.

Now I found this text "PHTree design refresh":
  http://phunq.net/pipermail/tux3/2013-January/000026.html
Ok, this has helpful info and further links on HTree/PHTree.

-- 
cu
Uenal


