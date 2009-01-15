From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12224] journal activity on inactive partition causes inactive harddrive spinup
Date: Wed, 14 Jan 2009 17:09:33 -0800 (PST)
Message-ID: <20090115010933.21E6F108048@picon.linux-foundation.org>
References: <bug-12224-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43008 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754079AbZAOBJf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Jan 2009 20:09:35 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0F19XND009131
	for <linux-ext4@vger.kernel.org>; Wed, 14 Jan 2009 17:09:34 -0800
In-Reply-To: <bug-12224-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12224





------- Comment #18 from csights@fastmail.fm  2009-01-14 17:09 -------
http://bugzilla.kernel.org/show_bug.cgi?id=12224

        I applied the patch to 2.6.28....
        However there is still activity on the inactive partition (sda) if
there is 
activity on the other partition (hda).
        I've pasted the current output of 'btrace /dev/sda' in case it has
changed 
from before.



Jan 14 19:51:29 localhost logger:   8,0    0        1     0.000000000  1138  A  
WS 12599 + 8 <- (8,1) 12536
Jan 14 19:51:29 localhost logger:   8,0    0        2     0.000006426  1138  Q  
WS 12599 + 8 [kjournald]
Jan 14 19:51:29 localhost logger:   8,0    0        3     0.000044978  1138  G  
WS 12599 + 8 [kjournald]
Jan 14 19:51:29 localhost logger:   8,0    0        4     0.000066489  1138  P  
N [kjournald]
Jan 14 19:51:29 localhost logger:   8,0    0        5     0.000081295  1138  I  
W 12599 + 8 [kjournald]
Jan 14 19:51:29 localhost logger:   8,0    0        6     0.000300597  1138  D  
W 12599 + 8 [kjournald]
Jan 14 19:51:29 localhost logger:   8,0    0        7     0.000492521  1138  U  
N [kjournald] 1
Jan 14 19:51:29 localhost logger:   8,0    0        8     0.041120321     3  C  
W 12599 + 8 [0]
Jan 14 19:51:51 localhost logger:   8,0    0        9    21.646946652  1138  A  
WS 12607 + 8 <- (8,1) 12544
Jan 14 19:51:51 localhost logger:   8,0    0       10    21.646955591  1138  Q  
WS 12607 + 8 [kjournald]
Jan 14 19:51:51 localhost logger:   8,0    0       11    21.646991071  1138  G  
WS 12607 + 8 [kjournald]
Jan 14 19:51:51 localhost logger:   8,0    0       12    21.647011464  1138  P  
N [kjournald]
Jan 14 19:51:51 localhost logger:   8,0    0       13    21.647027109  1138  I  
W 12607 + 8 [kjournald]
Jan 14 19:51:51 localhost logger:   8,0    0       14    21.647229369  1138  D  
W 12607 + 8 [kjournald]
Jan 14 19:51:51 localhost logger:   8,0    0       15    21.647339439  1138  U  
N [kjournald] 1
Jan 14 19:51:51 localhost logger:   8,0    0       16    21.688494962     3  C  
W 12607 + 8 [0]
Jan 14 19:51:55 localhost logger:   8,0    0       17    26.471770149  1138  A  
WS 12615 + 8 <- (8,1) 12552
Jan 14 19:51:55 localhost logger:   8,0    0       18    26.471779368  1138  Q  
WS 12615 + 8 [kjournald]
Jan 14 19:51:55 localhost logger:   8,0    0       19    26.471812613  1138  G  
WS 12615 + 8 [kjournald]
Jan 14 19:51:55 localhost logger:   8,0    0       20    26.471831889  1138  P  
N [kjournald]
Jan 14 19:51:55 localhost logger:   8,0    0       21    26.471846136  1138  I  
W 12615 + 8 [kjournald]
Jan 14 19:51:55 localhost logger:   8,0    0       22    26.472050632  1138  D  
W 12615 + 8 [kjournald]
Jan 14 19:51:55 localhost logger:   8,0    0       23    26.472162099  1138  U  
N [kjournald] 1
Jan 14 19:51:55 localhost logger:   8,0    0       24    26.481685099     3  C  
W 12615 + 8 [0]


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
