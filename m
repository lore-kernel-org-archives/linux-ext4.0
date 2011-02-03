From: Michael Rubin <mrubin@google.com>
Subject: [LSF/FS TOPIC] Local file systems in the cloud
Date: Thu, 3 Feb 2011 13:30:16 -0800
Message-ID: <AANLkTimp4s6iXM=_o5AgzHMApHhmtZqCc6Ex_p9bHdD=@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: lsf-pc <lsf-pc@lists.linuxfoundation.org>,
	linux-fsdevel@vger.kernel.org,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I would like to discuss the trade offs of a local file system in the
cloud. Google now runs over 80% of its storage on ext4 as opposed to
ext2. We can discuss the advantages and benefits we gained from this
upgrade in performance. Google has seen over 100% performance
improvements and availability in many dimensions for its workloads.
Hopefully we can relate our experience in upgrading a large cloud
ecosystem file system while it is still running.

Ext4 is just a first step towards our achieving our goals in local
file system cloud storage. It still presents many challenges and
surprises. Cloud local file systems have different requirements than
desktops or even server file systems. Everything from needing to
extend fsync semantics to Linux's lack of advanced performance file
system tools can cause havoc in a data center. Many of these are
characteristic of all Linux file systems and need to be addressed for
Linux to provide a full featured cloud ready local file system.

Linux is running more and more cloud storage solutions, from facebook
to myspace to that local startup in your nephew's basement.
Understanding what the community sees as the future in this area, and
exchanging experiences is important to raise the bar for Linux file
systems in the cloud. It should be fun too.

mrubin
