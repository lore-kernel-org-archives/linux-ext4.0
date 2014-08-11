From: Li Xi <pkuelelixi@gmail.com>
Subject: Re: [PATCH v2 0/4] quota: add project quota support
Date: Mon, 11 Aug 2014 08:19:45 +0800
Message-ID: <CAPTn0cD03NJTTKWrFB29HGEVmAPX8HkzMC9Ap5kzFXENE2dEXw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"hch@infradead.org" <hch@infradead.org>, Jan Kara <jack@suse.cz>,
	Andreas Dilger <adilger@dilger.ca>,
	"Niu, Yawei" <yawei.niu@intel.com>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:50556 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbaHKATq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 10 Aug 2014 20:19:46 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> That's fair enough, though I think you'll find that the plain
> project quota will find many different uses that filesystem
> developers will have never thought of if it is there. e.g. I came
> across an embedded NAS device a few years ago implemented with a
> centralised object stores but had per-export space usage accounting
> and enforcement by assigning every object associated with a specific
> exported volume the same project quota....
100% agreed. I can imagine that a lot of users will find their requirement
of space managing with project quota. In this sense, general project quota
is just like extended attribute comparing to internal attribute. For unknown
use case in the future, I' d suggest to keep everything flexible. We don't
really want to hear from customers that project quota looks attractive, but
needs to be hacked to be usable for their usage.

Regards,
Li Xi
