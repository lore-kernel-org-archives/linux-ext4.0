From: "Peter Meier" <meiepeter@gmail.com>
Subject: Re: Trying out 2.6.26-ext4-3
Date: Fri, 1 Aug 2008 11:03:53 +0200
Message-ID: <c354edc90808010203g6332e69bg2aeb85cce540c4e4@mail.gmail.com>
References: <c354edc90807270328gb835f39g530dc8173e7284f8@mail.gmail.com>
	 <20080727202302.GA7922@mit.edu>
	 <c354edc90807280811l57c39321lc7e6abeab2a82eb1@mail.gmail.com>
	 <20080728170110.GF9378@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.229]:46760 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbYHAJDy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Aug 2008 05:03:54 -0400
Received: by rv-out-0506.google.com with SMTP id k40so968450rvb.1
        for <linux-ext4@vger.kernel.org>; Fri, 01 Aug 2008 02:03:53 -0700 (PDT)
In-Reply-To: <20080728170110.GF9378@mit.edu>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

I'm happy to report that I'm writing this from a system installed
on ext4 w/ 2.6.26-ext4-4 and default mount options: Everything
went well once the journal credits patch was out of the mix. My
heaviest load so far were multiple parallel -j3 builds of C++ app-
lications, and I apparently didn't have any crashes, either.


Greetings,
Peter
