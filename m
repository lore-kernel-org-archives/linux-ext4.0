From: Ric Wheeler <ricwheeler@gmail.com>
Subject: default ext3 journal mode - time to poke at this again?
Date: Sat, 18 Jul 2009 08:54:37 -0400
Message-ID: <4A61C60D.5090702@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	"Stephen C. Tweedie" <sct@redhat.com>,
	Theodore Tso <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	Eric Sandeen <esandee
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:57125 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbZGRMyq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 18 Jul 2009 08:54:46 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


At the linux symposium this week, some of us were wondering when it 
would be safe to try and default ext3's default journal mode back to 
sanity given that all (?) distros immediately reverted the default to 
data writeback mode.

Failing that, can we at least clean up the config option description to 
properly give the normal users a non-bogus, technical description of the 
trade off ?

Thanks!

Ric

