From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3] Fix ext4 fault handling when mounted with -o dax,ro
Date: Tue, 29 Aug 2017 14:20:02 -0700
Message-ID: <20170829212002.GA2154@infradead.org>
References: <CAC9jV4pfQr=z9dHqtnTP8kAXGReeLDZWAAAfW2a7KRsK22UWkA@mail.gmail.com>
 <416a465a9fbe1d27085883dbf652c115cd195697.1503523424.git.dodgen@google.com>
 <20170824160144.GA14287@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu,
        Randy Dodgen <dodgen@google.com>, linux-nvdimm@lists.01.org
To: rdodgen@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:32944 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751263AbdH2VUE (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Aug 2017 17:20:04 -0400
Content-Disposition: inline
In-Reply-To: <20170824160144.GA14287@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Randy, any chance yto at least share a test script so that others
can wire it up for the test suite?
