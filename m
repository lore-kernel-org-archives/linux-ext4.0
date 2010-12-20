From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25352] New: resizing ext4 will corrupt filesystem
Date: Mon, 20 Dec 2010 20:56:46 GMT
Message-ID: <bug-25352-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:55547 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933048Ab0LTU4r (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Dec 2010 15:56:47 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id oBKKuk2V014793
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 20 Dec 2010 20:56:46 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=25352

           Summary: resizing ext4 will corrupt filesystem
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.37-rc6
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: kees@outflux.net
        Regression: Yes


Using resize2fs on an ext4 will result in a corrupted filesystem. This is a
regression (obviously).

I would expect "fsck" to be clean on a recently resized filesystem, but it is
not:

Pass 5: Checking group summary information
Block bitmap differences:  +(2621440--2621951) +(2654210--2655360)
+(2686976--2687487) +(2719744--2720255) +(2752512--2753023) +(2785280--2785791)
+(2818048--2818559) +(2850816--2851327) +(2883584--2884095) +(2916352--2916863)
+(2949120--2949631) +(2981888--2982399) +(3014656--3015167) +(3047424--3047935)
+(3080192--3080703) +(3112960--3113471) +(3145728--3146239) +(3178496--3179007)
+(3211264--3211775) +(3244032--3244543) +(3276800--3277311) +(3309568--3310079)
+(3342336--3342847) +(3375104--3375615) +(3407872--3408383) +(3440640--3441151)
+(3473408--3473919) +(3506176--3506687) +(3538944--3539455) +(3571712--3572223)
+(3604480--3604991) +(3637248--3637759) +(3670016--3670527) +(3702784--3703295)
+(3735552--3736063) +(3768320--3768831) +(3801088--3801599) +(3833856--3834367)
+(3866624--3867135) +(3899392--3899903)

etc

Reproducer script attached...

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
