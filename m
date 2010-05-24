From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16019] Resume from hibernate corrupts ext4
Date: Mon, 24 May 2010 17:00:07 GMT
Message-ID: <201005241700.o4OH07OE029883@demeter.kernel.org>
References: <bug-16019-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:33397 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757695Ab0EXRAH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 May 2010 13:00:07 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o4OH07up029884
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 24 May 2010 17:00:07 GMT
In-Reply-To: <bug-16019-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16019





--- Comment #18 from David Lowe <lowe@brown.edu>  2010-05-24 17:00:01 ---
(In reply to comment #17)
> Based on another internal redhat bug suggestion - does booting with the
> "iommu=soft" kernel parameter affect the bug at all?
> 
> thanks,
> -Eric

Back in Fedora 11 everything was working fine. With Fedora 12 so many things
regressed at the same time that testing was impractical (I think mostly intel
stack related...). I think suspend to ram worked fine, and hibernation would
just freeze. However with Fedora 13 I am really just left with this one
problem, hibernation. 

iommu=soft gave me one clean hibernation from inside gnome, but the second
attempt gave me the same ext4-fs errors

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching someone on the CC list of the bug.
