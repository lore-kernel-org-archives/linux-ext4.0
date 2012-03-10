From: Ted Ts'o <tytso@mit.edu>
Subject: Re: getdents - ext4 vs btrfs performance
Date: Fri, 9 Mar 2012 22:52:02 -0500
Message-ID: <20120310035202.GA5652@thunk.org>
References: <CADDYkjS5VJeYyHzqumazQ0qKg+HwA6GO+zYSJj7rkHNZFwjcoQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org
To: Jacek Luczak <difrost.kernel@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CADDYkjS5VJeYyHzqumazQ0qKg+HwA6GO+zYSJj7rkHNZFwjcoQ@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hey Jacek,

I'm curious parameters of the set of directories on your production
server.  On an ext4 file system, assuming you've copied the
directories over, what are the result of this command pipeline when
you are cd'ed into the top of the directory hierarchy of interest
(your svn tree, as I recall)?

find . -type d -ls | awk '{print $7}' | sort -n | uniq -c

I'm just curious what the distribution of directories sizes are in
practice for your use case...

Thanks,

						- Ted


