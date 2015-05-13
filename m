From: "U.Mutlu" <for-gmane@mutluit.com>
Subject: Htree concept
Date: Wed, 13 May 2015 17:37:36 +0200
Message-ID: <mivr40$2lj$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55737 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965462AbbEMPhp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 May 2015 11:37:45 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1YsYj8-0004Ko-K8
	for linux-ext4@vger.kernel.org; Wed, 13 May 2015 17:37:42 +0200
Received: from ip4d14ab60.dynamic.kabel-deutschland.de ([77.20.171.96])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Wed, 13 May 2015 17:37:42 +0200
Received: from for-gmane by ip4d14ab60.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Wed, 13 May 2015 17:37:42 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,
I'm writing a toy-fs, and discover a major shortcoming
(finding a given child (dir/file) as fast as possible),
which other developers (ie. ext3/4) had encountered long ago too.
They introduced HTree. The info on HTree on the web is scarce
or I couldn't find the right texts/papers yet.
I wonder how HTree works on a conceptual basis.
Could a kind soul enligten me pls. TIA.

-- 
cu
Uenal

