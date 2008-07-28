From: "Peter Meier" <meiepeter@gmail.com>
Subject: Re: Trying out 2.6.26-ext4-3
Date: Mon, 28 Jul 2008 19:30:51 +0200
Message-ID: <c354edc90807281030n13dc262bg857d0050ec9779eb@mail.gmail.com>
References: <c354edc90807270328gb835f39g530dc8173e7284f8@mail.gmail.com>
	 <20080727202302.GA7922@mit.edu>
	 <3.0.6.32.20080728102524.01af2ff8@pop.west.cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.175]:60690 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756004AbYG1Raw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Jul 2008 13:30:52 -0400
Received: by wf-out-1314.google.com with SMTP id 27so5856668wfd.4
        for <linux-ext4@vger.kernel.org>; Mon, 28 Jul 2008 10:30:52 -0700 (PDT)
In-Reply-To: <3.0.6.32.20080728102524.01af2ff8@pop.west.cox.net>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Gary,

thanks for taking the time to write a comprehensive and informative reply!

I'm about to give 2.6.26-ext4-4 a try, which removes the journal credits
patch, and am going to leave delalloc enabled given Theo's confidence
in its stability under non-synthetic usage conditions. If I'm unlucky with that
as well, I'll finally try with nodelalloc once more, which went fine
until I for-
got to set rootflags and the credits patch made it eat itself.


Greetings,
Peter
