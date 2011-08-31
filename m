From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25832] kernel crashes when a mounted ext3/4 file system is
 physically removed
Date: Wed, 31 Aug 2011 05:07:29 GMT
Message-ID: <201108310507.p7V57TTe007178@demeter2.kernel.org>
References: <bug-25832-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:48770 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560Ab1HaFHa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 31 Aug 2011 01:07:30 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.4) with ESMTP id p7V57TSq007179
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 05:07:29 GMT
In-Reply-To: <bug-25832-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=25832





--- Comment #86 from rocko <rockorequin@hotmail.com>  2011-08-31 05:07:27 ---
@Alan: re your comment #78, how did you compile in netconsole support? I have
the following set in .config for my builds, which is the default in Ubuntu's
kernel:

CONFIG_NETCONSOLE=m
CONFIG_NETCONSOLE_DYNAMIC=y

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
