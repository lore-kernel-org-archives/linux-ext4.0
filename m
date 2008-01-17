From: "Abhishek Rai" <abhishekrai@google.com>
Subject: Re: [CALL FOR TESTING] Make Ext3 fsck way faster [2.6.24-rc6 -mm patch]
Date: Thu, 17 Jan 2008 07:47:54 -0500
Message-ID: <d9885f0f0801170447r1c2bfeb9l6c911bfa0113366f@mail.gmail.com>
References: <200801140839.01986.abhishekrai@google.com>
	 <20080114163412.83a8b18d.akpm@linux-foundation.org>
	 <20080115030441.a0270609.akpm@linux-foundation.org>
	 <20080115131533.GA5766@infradead.org> <20080115152801.GA7292@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "Theodore Tso" <tytso@mit.edu>,
	"Christoph Hellwig" <hch@infradead.org>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	"Abhishek Rai" <abhishekrai@google.com>,
	linux-kernel@vger.kerne
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:14743 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756329AbYAQMsD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Jan 2008 07:48:03 -0500
Received: from zps38.corp.google.com (zps38.corp.google.com [172.25.146.38])
	by smtp-out.google.com with ESMTP id m0HCluw2001380
	for <linux-ext4@vger.kernel.org>; Thu, 17 Jan 2008 12:47:57 GMT
Received: from rv-out-0910.google.com (rvbl15.prod.google.com [10.140.88.15])
	by zps38.corp.google.com with ESMTP id m0HCltfQ011584
	for <linux-ext4@vger.kernel.org>; Thu, 17 Jan 2008 04:47:56 -0800
Received: by rv-out-0910.google.com with SMTP id l15so456323rvb.26
        for <linux-ext4@vger.kernel.org>; Thu, 17 Jan 2008 04:47:55 -0800 (PST)
In-Reply-To: <20080115152801.GA7292@mit.edu>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jan 15, 2008 10:28 AM, Theodore Tso <tytso@mit.edu> wrote:
> Also, it's not just reducing fsck times, although that's the main one.
> The last time this was suggested, the rationale was to speed up the
> "rm dvd.iso" case.  Also, something which *could* be done, if Abhishek
> wants to pursue it, would be to pull in all of the indirect blocks
> when the file is opened, and create an in-memory extent tree that
> would speed up access to the file.  It's rarely worth doing this
> without metaclustering, since it doesn't help for sequential I/O, only
> random I/O, but with metaclustering it would also be a win for
> sequential I/O.  (This would also remove the minor performance
> degradation for sequential I/O imposed by metaclustering, and in fact
> improve it slightly for really big files.)
>
>                                         - Ted
>

Also, since the in memory extent tree will now occupy much less space,
we can keep them cached for a much longer time which will improve
performance of random reads. The new metaclustering patch is more
amenable to this trick since it reduces fragmentation thereby reducing
the number of extents.

Thanks,
Abhishek
