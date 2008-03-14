From: Girish Shilamkar <Girish.Shilamkar@Sun.COM>
Subject: Convert between journal features and strings
Date: Fri, 14 Mar 2008 23:59:29 +0530
Message-ID: <1205519369.3465.23.camel@alpha.linsyssoft.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7BIT
Cc: Ext4 Mailing List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sineb-mail-2.sun.com ([192.18.19.7]:39164 "EHLO
	sineb-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529AbYCNSU2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 14 Mar 2008 14:20:28 -0400
Received: from fe-apac-05.sun.com (fe-apac-05.sun.com [192.18.19.176] (may be forged))
	by sineb-mail-2.sun.com (8.13.6+Sun/8.12.9) with ESMTP id m2EIKamW017484
	for <linux-ext4@vger.kernel.org>; Fri, 14 Mar 2008 18:20:45 GMT
Received: from conversion-daemon.mail-apac.sun.com by mail-apac.sun.com
 (Sun Java System Messaging Server 6.2-6.01 (built Apr  3 2006))
 id <0JXQ00001G00S900@mail-apac.sun.com>
 (original mail from Girish.Shilamkar@Sun.COM) for linux-ext4@vger.kernel.org;
 Sat, 15 Mar 2008 02:20:16 +0800 (SGT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,
	e2p_string2feature() and e2p_feature2string() can operate on ext2/3/4
features list as there is only one struct feature feature_list[] and no
corresponding journal features list. 
After introducing journal_checksum and journal_async_commit features, we
needed to display the features using debugfs which does it through the
two e2p_* functions. A new struct feature jrnl_feature_list[] was added.
The e2p_* functions were passed an additional argument so it can decide
which feature list to use.
Change in the APIs of e2p_* functions might not be acceptable so we have
an option to either make e2p_feature2string2() function or add
a new e2p_jnl_feature2string()

Would like to know what will be preferred e2p_feature2string2() or
e2p_jnl_feature2string() ?

Thanks,
Girish



