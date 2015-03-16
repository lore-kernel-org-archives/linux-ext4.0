From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 0/2] ext4: Add pollable sysfs entry for block
 threshold events
Date: Mon, 16 Mar 2015 06:28:43 -0700
Message-ID: <20150316132843.GA8188@infradead.org>
References: <1426512329-24299-1-git-send-email-b.michalska@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: lczerner@redhat.com, adilger.kernel@dilger.ca, tytso@mit.edu,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	kyungmin.park@samsung.com
To: Beata Michalska <b.michalska@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1426512329-24299-1-git-send-email-b.michalska@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Between this and the recent tmpfs discussion I really think this
needs to be done in a generic way.  Given that the quota noticiations
already use netlink general space notifications seem like a very
sensible extension for them.
