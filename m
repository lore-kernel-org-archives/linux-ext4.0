From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Subject: ext4_readdir ignores filldir error code
Date: Mon, 24 Sep 2012 15:47:24 +0300
Message-ID: <CALLzPKYO=Ccajri9Yv5OsZ=Z9X3=4n9NacqNmx4QC_Ra8yPpqQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello,

I noticed following in ext4_readdir() and in other file systems..

filldir returns error in "error":
       error = filldir(dirent, de->name, ...)

But function itself returns "ret"

What I can see is that when filldir fails, ext4_readir quits, but with
no error....
       while (!error && !stored && filp->f_pos < inode->i_size) {


Is it by design or an error?

- Dmitry
