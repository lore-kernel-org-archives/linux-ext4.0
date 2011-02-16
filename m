From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 29212] noexec on file level (acl)
Date: Wed, 16 Feb 2011 18:20:42 GMT
Message-ID: <201102161820.p1GIKg4c008501@demeter2.kernel.org>
References: <bug-29212-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:48839 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857Ab1BPSUn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Feb 2011 13:20:43 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p1GIKgW3008502
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 16 Feb 2011 18:20:43 GMT
In-Reply-To: <bug-29212-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=29212





--- Comment #3 from krzf83@gmail.com  2011-02-16 18:20:41 ---
denying executing code has little to do with filesystem. Noexec was implemented
as mount flag so there is no problem of specifing more precice paths to
dissalow exec-ing - laziness

fs/open.c


        if ((mode & MAY_EXEC) && S_ISREG(inode->i_mode)) {
                /*
                 * MAY_EXEC on regular files is denied if the fs is mounted
                 * with the "noexec" flag.
                 */
                res = -EACCES;
                if (path.mnt->mnt_flags & MNT_NOEXEC)
                        goto out_path_release;
        }

if there were next if but with checking against list of paths in a file (if not
xattr) instead of MNT_NOEXEC. I'm not good in c so I have no way of programing
this stuff any time soon.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
