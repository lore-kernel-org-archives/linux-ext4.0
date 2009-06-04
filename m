From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 12624] umount hangs after fsstress with data=journal
Date: Thu, 4 Jun 2009 06:32:22 GMT
Message-ID: <200906040632.n546WMD2015261@demeter.kernel.org>
References: <bug-12624-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:36979 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbZFDGcU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Jun 2009 02:32:20 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n546WMD7015262
	for <linux-ext4@vger.kernel.org>; Thu, 4 Jun 2009 06:32:22 GMT
In-Reply-To: <bug-12624-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12624





--- Comment #6 from Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>  2009-06-04 06:32:22 ---
On Wed, Jun 03, 2009 at 09:51:42PM +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=12624
> 
> 
> 
> 
> 
> --- Comment #5 from Theodore Tso <tytso@mit.edu>  2009-06-03 21:51:42 ---
> On Fri, May 22, 2009 at 06:51:43AM +0000, bugzilla-daemon@bugzilla.kernel.org
> wrote:
> > I guess we would need this patch. But i am still hitting the BUG_ON.
> > Will try to debug further later today.
> > 
> > -aneesh
> > 
> > commit 85ddb1581222bac63035c16a6536b0a5a2cd60a0
> > Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> > Date:   Thu May 21 23:58:17 2009 +0530
> > 
> >     ext4: Don't look at buffer_heads outside i_size.
> > 
> > 
> >     Buffer heads outside i_size will be unmapped. So when we
> >     are doing "walk_page_buffers" limit ourself to i_size.
> > 
> >     Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> 
> OK, added to the ext4 patch tree.


can you add

Reviewed-by: Josef Bacik <jbacik@redhat.com>
Acked-by: Jan Kara <jack@suse.cz> 

As can be found here

http://article.gmane.org/gmane.comp.file-systems.ext4/13470
http://article.gmane.org/gmane.comp.file-systems.ext4/13479

-aneesh

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
