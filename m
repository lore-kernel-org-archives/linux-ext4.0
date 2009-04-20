From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] Add ext3 data=guarded mode
Date: Mon, 20 Apr 2009 11:26:04 +0200
Message-ID: <20090420092604.GB14699@duck.suse.cz>
References: <1239816159-6868-1-git-send-email-chris.mason@oracle.com> <a22f99ce2199ebebe63228edd8afa4809511ab1e.1239815649.git.chris.mason@oracle.com> <1239910921.21233.98.camel@think.oraclecorp.com> <20090417180906.GA8363@amit-x200.pnq.redhat.com> <20090417201342.GF26479@mit.edu> <20090418060312.GA10943@amit-x200.pnq.redhat.com> <1240039701.6298.12.camel@marge.simson.net> <20090419062448.GA13272@amit-x200.pnq.redhat.com> <1240218437.7005.27.camel@marge.simson.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Nq2Wo0NMKNjxTN9z"
Cc: Amit Shah <amit.shah@redhat.com>, Theodore Tso <tytso@mit.edu>,
	Chris Mason <chris.mason@oracle.com>, Jan Kara <jack@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Mike Galbraith <efault@gmx.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54363 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753312AbZDTJ0J (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Apr 2009 05:26:09 -0400
Content-Disposition: inline
In-Reply-To: <1240218437.7005.27.camel@marge.simson.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon 20-04-09 11:07:17, Mike Galbraith wrote:
> On Sun, 2009-04-19 at 11:54 +0530, Amit Shah wrote:
> > On (Sat) Apr 18 2009 [09:28:21], Mike Galbraith wrote:
> 
> > > Probably because you're swapping heavily, and that is perturbing your
> > 
> > The variance only affects the 4k test; the other times more or less
> > remain the same.
> 
> My box disagrees.
> 
> (bumps ulimits to test 4BG... OS+swap live on sdb btw)
> 
> ./test-file-zero-alloc-speed 4 /dev/sdf3 /media/root ext3 rw,_netdev,noatime,data=foo,acl,user_xattr
> 
> foo=guarded
> 4k   225  141   80  142  361
> 8k    74   96  362   78   84
> mm    55   57   57   57   57
> 
> foo=writeback
> 4k   179  264  187  125   93
> 8k    94  161   73  334   84
> mm    57   58   57   56   57
> 
> foo=ordered
> 4k    81   74   76   80   75
> 8k    77   76  224   79   79 
> mm    59   56   60   58   59
> 
> foo=journal
> 4k    95  297   69   83  420
> 8k    73  139  158   80   78
> mm    57   58   56   59   56
> 
> ./test-file-zero-alloc-speed 2 /dev/sdf3 /media/root ext3 rw,_netdev,noatime,data=foo,acl,user_xattr
> 
> foo=guarded
> 4k    28   27   27   28   28
> 8k    28   27   27   28   27
> 
> foo=writeback
> 4k    27   27   27   27   27
> 8k    28   28   27   27   28
> 
> All journal modes seem subject to bad throughput under heavy pressure,
> though data=ordered seems much less likely to suffer for some reason.
> Major difference _seems_ to be that write()+largefile induces very much
> swap activity.
  My rough guess is that this depends on the VM writeout behavior. In
ordered mode, we forcibly writeout all the dirty data on a transaction
commit which happens every 5 seconds so they don't accumulate that much.
In other journaling modes we don't do that and decisions about writeout
(probably how much pdflush manages to write in background vs. how much
VM throttles the process to do the writeback itself) cause variances in
the run time. But this is just a guess. You could gather blktraces of
slow and fast runs and then look if the amount of IO done by different
processes significantly differs. If Chris has merged by improvements to
Seekwatcher, then you could nicely visualize this (hmm, that doesn't seem
to be the case so I'm attaching the diff and a helper script - see comments
in the beginning of the script and command helps for usage).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--Nq2Wo0NMKNjxTN9z
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="seekwatcher-tagging.diff"

--- seekwatcher.orig	2009-01-15 00:04:20.000000000 +0100
+++ seekwatcher	2009-01-26 12:04:21.000000000 +0100
@@ -56,6 +56,7 @@
 from optparse import OptionParser
 
 blktrace_only = False
+tags = { "": 0 }
 
 try:
     from matplotlib import rcParams
@@ -136,9 +137,9 @@
     return 2.0
     sys.stderr.write("unknown command %s\n" % com)
 
-def loaddata(fh,delimiter=None, converters=None):
+def loaddata(fh,delimiter=None, converters=None, filter=True):
 
-    def iter(fh, delimiter, converters):
+    def iter(fh, delimiter, converters, filter):
         global devices_sector_max
 
         if converters is None: converters = {}
@@ -149,10 +150,20 @@
         last_cmd = None
         last_size = None
         last_dev = None
+        last_tag = None
         for i,line in enumerate(fh):
-            if not line.startswith('C'):
+            if filter and not line.startswith('C'):
                 continue
-            row = [converters.get(i,float)(val) for i,val in enumerate(line.split(delimiter))]
+            if not filter:
+                line = "C " + line
+            this_tag = 0
+            row = []
+            for i,val in enumerate(line.split(delimiter)):
+                if i < 9:
+                    row.append(converters.get(i,float)(val))
+                else:
+		    this_tag = tags.setdefault(val, len(tags))
+            row.append(this_tag)
             this_time = row[7]
             this_dev = row[8]
             this_sector = row[4]
@@ -165,7 +176,7 @@
             if (last_row and this_rw == last_rw and
                 this_dev == last_dev and
                 this_time - last_time < .5 and last_size < 512 and
-                this_sector == last_end):
+                this_sector == last_end and this_tag == last_tag):
                 last_end += this_size
                 last_size += this_size
                 last_row[5] += row[5]
@@ -182,11 +193,12 @@
             last_end = this_sector + this_size
             last_size = this_size
             last_dev = this_dev
+            last_tag = this_tag
         if last_row:
             for x in last_row:
                 yield x
 
-    X = numpy.fromiter(iter(fh, delimiter, converters), dtype=float)
+    X = numpy.fromiter(iter(fh, delimiter, converters, filter), dtype=float)
     return X
 
 def sort_by_time(data):
@@ -367,7 +379,7 @@
             os.remove(os.path.join(root, name))
     os.rmdir(png_dir)
 
-def plot_data(ax, rw, data, style, label, alpha=1):
+def plot_data(ax, data, style, label, alpha=1):
     def reduce_plot():
         reduce = {}
         skipped = 0
@@ -380,37 +392,48 @@
             y += 1
             h = reduce.setdefault(x, {})
             h[y] = 1
+            yield rbs[i]
             yield x * x_per_cell
             yield y * y_per_cell
+            yield tg[i]
     xcells = 325.0 * options.io_graph_cell_multi
     x_per_cell = (xmax - xmin) / xcells
     ycells = 80.0 * options.io_graph_cell_multi
     y_per_cell = (yzoommax - yzoommin) / ycells
 
-    if rw is None:
-        if options.reads_only:
-            rw = 0
-        if options.writes_only:
-            rw = 1
-    if rw != None:
-        if options.reads_only and rw != 0:
-            return
-        if options.writes_only and rw != 1:
-            return
-        rbs = data[:,1]
-        data = data[numpy.where(rbs == rw)]
+    rbs = data[:,1]
+    if options.reads_only:
+        data = data[numpy.where(rbs == 0)]
+    if options.writes_only:
+        data = data[numpy.where(rbs == 1)]
+
+    if len(data) == 0:
+        return []
+
     times = data[:,7]
     sectors = data[:,4]
-    if len(times) > 0:
-        t = numpy.fromiter(reduce_plot(), dtype=float)
-        t.shape = (len(t)/2, 2)
-        xdata = t[:,0]
-        ydata = t[:,1]
-        lines = ax.plot(t[:,0], t[:,1], options.io_graph_dots, mew=0,
-                        ms=options.io_graph_marker_size,
-                        label=label, alpha=alpha)
-        return lines
-    return []
+    tg = data[:,9]
+    t = numpy.fromiter(reduce_plot(), dtype=float)
+    t.shape = (len(t)/4, 4)
+    lines = []
+    for tag in tags:
+        at = t[numpy.where(t[:,3] == tags[tag])]
+        if len(at) == 0:
+            continue
+        if not options.writes_only:
+            atr = at[numpy.where(at[:,0] == 0)]
+            lines.extend(ax.plot(atr[:,1], atr[:,2], style, mew=0,
+                                 ms=options.io_graph_marker_size,
+                                 alpha=alpha,
+                                 label=tag + " Reads " + label))
+        if not options.reads_only:
+            atr = at[numpy.where(at[:,0] == 1)]
+            lines.extend(ax.plot(atr[:,1], atr[:,2], style, mew=0,
+                                 ms=options.io_graph_marker_size,
+                                 alpha=alpha,
+                                 label=tag + " Writes " + label))
+    return lines
+
 
 def add_roll(roll, max, num):
     if len(roll) == max:
@@ -624,11 +647,11 @@
     return data
 
 def shapeit(X):
-    lines = len(X) / 9
-    X.shape = (lines, 9)
+    lines = len(X) / 10
+    X.shape = (lines, 10)
 
 def unshapeit(X):
-    lines = len(X) * 9
+    lines = len(X) * 10
     X.shape = (lines, 1)
 
 def getlabel(i):
@@ -692,12 +715,49 @@
 def translate_sector(dev, sector):
     return device_translate[dev] + sector;
 
+def process_input(input, type):
+    global devices_sector_max
+    global device_translate
+    global must_sort
+
+    devices_sector_max = {}
+    if type == 0:
+        run = run_blkparse(input, converters)
+    elif type == 1:
+        if input == "-":
+            p = sys.stdin
+        else:
+            p = open(input, 'r')
+        run = loaddata(p, converters=converters, filter=False)
+
+    device_translate = {}
+    total = 0
+    if len(devices_sector_max) > 1:
+        must_sort = True
+        for x in devices_sector_max:
+            device_translate[x] = total + devices_sector_max[x]
+            total += devices_sector_max[x]
+    shapeit(run)
+    if len(devices_sector_max) > 1:
+        for x in run:
+            sector = x[4]
+            dev = x[8]
+            x[4] = device_translate[dev] + sector
+        
+    sorted = sort_by_time(run)
+    run = sorted
+
+    unshapeit(run)
+    return run
+
 usage = "usage: %prog [options]"
 parser = OptionParser(usage=usage)
 parser.add_option("-d", "--device", help="Device for blktrace", default=[],
                   action="append")
 parser.add_option("-t", "--trace", help="blktrace file", default=[],
                   action="append")
+parser.add_option("-f", "--file", help="parsed blktrace file", default=[],
+                  action="append")
 parser.add_option("-p", "--prog", help="exec program", default="")
 parser.add_option("", "--full-trace", help="Don't filter blktrace events",
                   default=False, action="store_true")
@@ -710,7 +770,7 @@
     parser.add_option("-o", "--output", help="output file", default="trace.png")
     parser.add_option("-l", "--label", help="label", default=[],
                       action="append")
-    parser.add_option("", "--dpi", help="dpi", default=120)
+    parser.add_option("", "--dpi", help="dpi", default=120, type="float")
     parser.add_option("", "--io-graph-dots", help="Disk IO dot style",
                       default='s')
     parser.add_option("", "--io-graph-marker-size", help="Disk IO dot size",
@@ -719,6 +779,8 @@
                       default=2, type="float")
     parser.add_option("-I", "--no-io-graph", help="Don't create an IO graph",
                       default=False, action="store_true")
+    parser.add_option("", "--only-io-graph", help="Create only IO graph",
+                      default=False, action="store_true");
     parser.add_option("-r", "--rolling-avg",
                   help="Rolling average for seeks and throughput (in seconds)",
                   default=None)
@@ -761,7 +823,7 @@
         rcParams['interactive'] = 'False'
     from pylab import *
 
-if not options.trace:
+if not options.trace and not options.file:
     parser.print_help()
     sys.exit(1)
 
@@ -788,29 +850,16 @@
 data = numpy.array([])
 runs = []
 must_sort = True
+devices_sector_max = {}
+device_translate = {}
 
 for x in options.trace:
-    devices_sector_max = {}
-    run = run_blkparse(x, converters)
-
-    device_translate = {}
-    total = 0
-    if len(devices_sector_max) > 1:
-        must_sort = True
-        for x in devices_sector_max:
-            device_translate[x] = total + devices_sector_max[x]
-            total += devices_sector_max[x]
-    shapeit(run)
-    if len(devices_sector_max) > 1:
-        for x in run:
-            sector = x[4]
-            dev = x[8]
-            x[4] = device_translate[dev] + sector
-        
-    sorted = sort_by_time(run)
-    run = sorted
+    run = process_input(x, 0)
+    runs.append(run)
+    data = numpy.append(data, run)
 
-    unshapeit(run)
+for x in options.file:
+    run = process_input(x, 1)
     runs.append(run)
     data = numpy.append(data, run)
 
@@ -910,6 +959,8 @@
 
 if options.no_io_graph:
     total_graphs = 2
+elif options.only_io_graph:
+    total_graphs = 1
 else:
     total_graphs = 3
 
@@ -922,76 +973,78 @@
 if options.title:
     options.title += "\n\n"
 
-# Throughput goes at the botoom
-a = subplot(total_graphs, 1, total_graphs)
-for i in xrange(len(runs)):
-    label = getlabel(i)
-    plot_throughput(a, None, runs[i], '-', label)
-
+# Prepare ticks
 # make sure the final second goes on the x axes
 ticks = list(arange(xmin, xmax, xmax/8))
 ticks.append(xmax)
 xticks = ticks
-a.set_xticks(ticks)
-a.set_yticklabels( [ "%d" % x for x in ticks ])
 if ticks[-1] < 4:
     xticklabels = [ "%.1f" % x for x in ticks ]
 else:
     xticklabels = [ "%d" % x for x in ticks ]
-a.set_xticklabels(xticklabels)
 
-# cut down the number of yticks to something more reasonable
-ticks = a.get_yticks()
-ticks = list(arange(0, ticks[-1] + ticks[-1]/4, ticks[-1]/4))
-a.set_yticks(ticks)
+if not options.only_io_graph:
+    # Throughput goes at the botoom
+    a = subplot(total_graphs, 1, total_graphs)
+    for i in xrange(len(runs)):
+        label = getlabel(i)
+        plot_throughput(a, None, runs[i], '-', label)
 
-if ticks[-1] < 4:
-    a.set_yticklabels( [ "%.1f" % x for x in ticks ])
-else:
-    a.set_yticklabels( [ "%d" % x for x in ticks ])
+    a.set_xticks(xticks)
+    a.set_yticklabels( [ "%d" % x for x in xticks ])
+    a.set_xticklabels(xticklabels)
 
-a.set_title('Throughput')
-a.set_ylabel('MB/s')
+    # cut down the number of yticks to something more reasonable
+    ticks = a.get_yticks()
+    ticks = list(arange(0, ticks[-1] + ticks[-1]/4, ticks[-1]/4))
+    a.set_yticks(ticks)
 
-# the bottom graph gets xticks, set it here
-a.set_xlabel('Time (seconds)')
-if options.label:
-    a.legend(loc=(1.01, 0.5), shadow=True, pad=0.5, numpoints=2,
-                  handletextsep = 0.005,
-                  labelsep = 0.01,
-                  prop=FontProperties(size='x-small') )
-
-# next is the seek count graph
-a = subplot(total_graphs, 1, total_graphs - 1)
-for i in xrange(len(runs)):
-    label = getlabel(i)
-    plot_seek_count(a, None, runs[i], '-', label)
-
-# cut down the number of yticks to something more reasonable
-ticks = a.get_yticks()
-ticks = list(arange(0, ticks[-1] + ticks[-1]/4, ticks[-1]/4))
-a.set_yticks(ticks)
-a.set_yticklabels( [ str(int(x)) for x in ticks ])
+    if ticks[-1] < 4:
+        a.set_yticklabels( [ "%.1f" % x for x in ticks ])
+    else:
+        a.set_yticklabels( [ "%d" % x for x in ticks ])
 
-if options.no_io_graph and options.title:
-    a.set_title(options.title + 'Seek Count')
-else:
-    a.set_title('Seek Count')
+    a.set_title('Throughput')
+    a.set_ylabel('MB/s')
+
+    # the bottom graph gets xticks, set it here
+    a.set_xlabel('Time (seconds)')
+    if options.label:
+        a.legend(loc=(1.01, 0.5), shadow=True, pad=0.5, numpoints=2,
+                      handletextsep = 0.005,
+                      labelsep = 0.01,
+                      prop=FontProperties(size='x-small') )
 
-a.set_ylabel('Seeks / sec')
-if options.label:
-    a.legend(loc=(1.01, 0.5), shadow=True, pad=0.5, numpoints=2,
-                  handletextsep = 0.005,
-                  labelsep = 0.01,
-                  prop=FontProperties(size='x-small') )
+    # next is the seek count graph
+    a = subplot(total_graphs, 1, total_graphs - 1)
+    for i in xrange(len(runs)):
+        label = getlabel(i)
+        plot_seek_count(a, None, runs[i], '-', label)
+
+    # cut down the number of yticks to something more reasonable
+    ticks = a.get_yticks()
+    ticks = list(arange(0, ticks[-1] + ticks[-1]/4, ticks[-1]/4))
+    a.set_yticks(ticks)
+    a.set_yticklabels( [ str(int(x)) for x in ticks ])
+
+    if options.no_io_graph and options.title:
+        a.set_title(options.title + 'Seek Count')
+    else:
+        a.set_title('Seek Count')
+
+    a.set_ylabel('Seeks / sec')
+    if options.label:
+        a.legend(loc=(1.01, 0.5), shadow=True, pad=0.5, numpoints=2,
+                      handletextsep = 0.005,
+                      labelsep = 0.01,
+                      prop=FontProperties(size='x-small') )
 
 # and the optional IO graph
 if not options.no_io_graph:
-    a = subplot(total_graphs, 1, total_graphs - 2)
+    a = subplot(total_graphs, 1, 1)
     for i in xrange(len(runs)):
         label = getlabel(i)
-        plot_data(a, 0, runs[i], options.io_graph_dots, label + " Read")
-        plot_data(a, 1, runs[i], options.io_graph_dots, label + " Write")
+        plot_data(a, runs[i], options.io_graph_dots, label)
 
     af = AnnoteFinder(axis=a)
     connect('button_press_event', af)
@@ -1008,17 +1061,27 @@
     ticks.append(yzoommax)
     a.set_yticks(ticks)
     a.set_yticklabels( [ str(int(x/2048)) for x in ticks ] )
-    a.legend(loc=(1.01, 0.5), shadow=True, pad=0.3, numpoints=1,
-                  handletextsep = 0.005,
-                  labelsep = 0.01,
-                  markerscale = 1.1,
-                  prop=FontProperties(size='x-small') )
+    if not options.only_io_graph:
+        a.legend(loc=(1.01, 0.5), shadow=True, pad=0.3, numpoints=1,
+                 handletextsep = 0.005,
+                 labelsep = 0.01,
+                 markerscale = 1.1,
+                 prop=FontProperties(size='x-small') )
+    else:
+        a.legend(loc=(0,-0.25), ncol=4, columnspacing=0.1,
+                 shadow=True, borderpad=0.3, numpoints=1,
+                 handletextpad = 0.005,
+                 labelspacing = 0.01,
+                 markerscale = 1.1,
+                 prop=FontProperties(size='x-small') )
+        subplots_adjust(bottom=0.2)
     a.set_ylim(yzoommin, yzoommax)
 
-# squeeze the graphs over to the left a bit to make room for the
-# legends
-#
-subplots_adjust(right = 0.8, hspace=0.3)
+if not options.only_io_graph:
+    # squeeze the graphs over to the left a bit to make room for the
+    # legends
+    #
+    subplots_adjust(right = 0.8, hspace=0.3)
 
 # finally, some global bits for each subplot
 for x in xrange(1, total_graphs + 1):

--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=tag-by-process

#!/usr/bin/env python

# Copyright (C) 2009 Novell.  All rights reserved.
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public
# License v2 as published by the Free Software Foundation.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
# 
# You should have received a copy of the GNU General Public
# License along with this program; if not, write to the
# Free Software Foundation, Inc., 59 Temple Place - Suite 330,
# Boston, MA 021110-1307, USA.
#
# You can use this script to produce files for seekwatcher with
# IO tagged by PID and / or command. Use option -m <command> to
# merge processes which have the same command name.
#
# Example:
# tag-by-process -t sda | seekwatcher -f - --only-io-graph

import sys, os, signal, time, commands, tempfile, signal
from optparse import OptionParser

def loaddata(fh):
    for i,line in enumerate(fh):
        if not line.startswith('Q'):
            continue
        row = line.split()
        if options.merge.count(row[10]) > 0:
            row[9] = row[10]
        else:
            row[9] = row[10] + "(" + row[9] + ")"
        for i in range(1,10):
            print row[i],
        print

def run_blkparse(trace):
    tracefiles = []
    seen = {}
    sys.stderr.write("run_blkparse on %s\n" % trace)
    if not os.path.exists(trace + "blktrace.0"):
        dirname = os.path.dirname(trace) or "."
        files = os.listdir(dirname)
        joinname = os.path.dirname(trace) or ""
        for x in files:
            x = os.path.join(joinname, x)
            if x.startswith(trace) and ".blktrace." in x:
                i = x.rindex('.blktrace.')
                cur = x[0:i]
                if cur not in seen:
                    tracefiles.append(x[0:i])
                    seen[cur] = 1
    else:
        tracefiles.append(trace)

    for x in tracefiles:
        sys.stderr.write("using tracefile %s\n" % x)
        p = os.popen('blkparse -q -i ' + x +
             ' -f "%a %d %M %m %S %N %s %5T.%9t %D %p %C\n"')
        cur = loaddata(p)
 
usage = "usage: %prog [options]"
parser = OptionParser(usage=usage)
parser.add_option("-t", "--trace", help="blktrace file", default=[],
                  action="append")
parser.add_option("-m", "--merge", help="merge commands with given names",
                  default=[], action="append")

(options,args) = parser.parse_args()

for x in options.trace:
    run = run_blkparse(x)

--Nq2Wo0NMKNjxTN9z--
