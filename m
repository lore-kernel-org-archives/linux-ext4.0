From: Markus Heiser <markus.heiser@darmarit.de>
Subject: Re: Sphinx version dependencies?
Date: Fri, 20 Jul 2018 15:45:37 +0200
Message-ID: <d064f468ab9fc60a02242331e0dddc185d6556ba.camel@darmarit.de>
References: <20180719181556.GA21435@thunk.org>
         <20180719190400.GB4800@magnolia>
         <44d73cd9926f58976a1269ff3cd3afb845ec84fa.camel@darmarit.de>
         <20180720131206.GM30706@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180720131206.GM30706@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Am Freitag, den 20.07.2018, 09:12 -0400 schrieb Theodore Y. Ts'o:
> I'm not entirely sure what's the best approach.  Right now I just want
> to understand --- do I have to make ext4.rst work against one, or many
> versions of Sphinx?  And which version(s) of Sphinx do I need to
> concern myself with?  If that turns out to be an onerous burden, I'm
> sure I won't be the only person complaining.  :-)

In that case ...

> But when I did that, Sphinx had heartburn over the ext4.rst file.
> 
>     ./include/linux/spi/spi.h:373: ERROR: Unexpected indentation.
>     /usr/projects/linux/ext4/Documentation/filesystems/ext4/ext4.rst:139: ERROR: Malformed table.
>     Column span alignment problem in table line 5.

... its clear; the table was malformed. A markup error which is not detected
by older versions of docutils (very special case).

In general I recommend to install an up-to-date Sphinx-doc in a virtualenv .. this
is what I do in my projects ... and where I haven't seen those version problems ;)

If we have errors downward we have to handle them. The main thing is the markup
is correct.

  -- Markus --
